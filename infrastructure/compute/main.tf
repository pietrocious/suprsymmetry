terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Use your VPC module
module "vpc" {
  source = "../modules/vpc"
  
  vpc_cidr               = "10.1.0.0/16"
  environment            = "production"
  availability_zones     = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs    = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs   = ["10.1.11.0/24", "10.1.12.0/24"]
  enable_nat_gateway     = false  # Keep costs down
}

# Security Group for ALB (public-facing)
resource "aws_security_group" "alb" {
  name        = "production-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "production-alb-sg"
    Environment = "production"
  }
}

# Security Group for EC2 instances
resource "aws_security_group" "instances" {
  name        = "production-instances-sg"
  description = "Security group for EC2 instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

ingress {
    description = "SSH from main instance"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]  # Your VPC CIDR (allows SSH from any instance in VPC)
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "production-instances-sg"
    Environment = "production"
  }
}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "production-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnet_ids

  tags = {
    Name        = "production-alb"
    Environment = "production"
  }
}

# Target Group
resource "aws_lb_target_group" "app" {
  name     = "production-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "production-tg"
    Environment = "production"
  }
}

# ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# Get latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# Launch Template
resource "aws_launch_template" "app" {
  name_prefix   = "production-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = "terraform" 

  vpc_security_group_ids = [aws_security_group.instances.id]

user_data = base64encode(<<-EOF
  #!/bin/bash
  yum update -y
  yum install -y httpd stress
  systemctl start httpd
  systemctl enable httpd
  echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
  
  sleep 60
  stress --cpu 4 --vm 2 --vm-bytes 128M --timeout 600 &
  EOF
)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "production-instance"
      Environment = "production"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  name                = "production-asg"
  vpc_zone_identifier = module.vpc.public_subnet_ids
  target_group_arns   = [aws_lb_target_group.app.arn]
  health_check_type   = "ELB"
  health_check_grace_period = 300

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "production-asg-instance"
    propagate_at_launch = true
  }
}
