# production AWS infrastructure

production-grade AWS infrastructure with auto-scaling, automated monitoring, and infrastructure-as-code using Terraform.

posting updates & soon video walk-through :)

## capabilities

**week 1: vpc networking & CI/CD** 

- custom vpc with public/private subnets across multiple availability zones
- reusable terraform modules for infrastructure components
- github actions ci/cd pipeline for automated validation on every commit
- secure aws credential management via github secrets

**week 2: Auto-Scaling Infrastructure** *(Current)*

- application load balancer distributing traffic across multiple availability zones
- auto scaling groups with cpu-based scaling policies (scales 2-4 instances)
- cloudwatch monitoring with sns alerts on high/low cpu and unhealthy targets
- automated failover and self-healing infrastructure

## tech stack

- **infrastructure:** AWS (vpc, ec2, alb, asg, cloudwatch, sns)
- **IaC:** Terraform with reusable modules
- **CI/CD:** GitHub Actions for automated validation
- **monitoring:** CloudWatch metrics and alarms

## architecture info

multi-AZ VPC with public/private subnets, internet gateway, and route tables. ALB in public subnets distributes traffic to Auto Scaling Group instances that automatically scale based on CPU utilization.

## monitoring (in progress)

CloudWatch alarms configured for:

- high CPU (>15%) → triggers scale-up
- low CPU (<30%) → triggers scale-down
- unhealthy targets → immediate sns notification

## project structure

```
suprsymmetry/
├── .github/
│   └── workflows/
│       └── terraform.yml      # ci/cd pipeline for automated validation
├── production-infrastructure/  # week 2: auto-scaling infrastructure
│   ├── main.tf                # alb, asg, launch template, security groups
│   ├── monitoring.tf          # cloudwatch alarms, sns topics, scaling policies
│   └── outputs.tf             # alb dns name and vpc id
├── vpc-module-project/        # week 1: reusable vpc module
│   ├── main.tf                # module usage example
│   ├── outputs.tf             # vpc and subnet outputs
│   └── modules/
│       └── vpc/               # reusable vpc module (subnets, igw, route tables)
├── archive/                   # early experiments and learning iterations
│   └── week1-experiments/
└── README.md

```

## TODO

- [x]  Week 1: VPC networking and CI/CD foundation
- [x]  Week 2: Auto-scaling infrastructure with monitoring
- [ ]  Week 3: Static website deployment (S3, CloudFront, Route53)
- [ ]  Week 4: Container orchestration with EKS
- [ ]  Week 5: Remote state management and multi-environment
- [ ]  Week 6: Security hardening and compliance
