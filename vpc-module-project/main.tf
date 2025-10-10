terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}

# Call the VPC module
module "dev_vpc" {
  source = "./modules/vpc"
  
  vpc_cidr               = "10.0.0.0/16"
  environment            = "dev"
  availability_zones     = ["eu-west-3a", "eu-west-3b"]
  public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs   = ["10.0.11.0/24", "10.0.12.0/24"]
  enable_nat_gateway     = true
}




