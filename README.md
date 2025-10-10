# DevOps Learning - Terraform Infrastructure Projects

Learning DevOps and Infrastructure-as-Code through hands-on Terraform projects.

## Projects

### 1. VPC Networking (`vpc-networking/`)
Production-ready AWS VPC with:
- Public and private subnets across multiple availability zones
- Internet Gateway for public subnet internet access
- NAT Gateway for private subnet outbound connectivity
- Route tables with proper associations

**Skills demonstrated:**
- Terraform resource management
- AWS networking fundamentals
- Multi-AZ high availability patterns

### 2. VPC Module (`vpc-module-project/`)
Refactored VPC infrastructure into a reusable Terraform module.

**Features:**
- Parameterized configuration (CIDR blocks, AZs, environment)
- Conditional NAT Gateway (enable/disable for cost optimization)
- Dynamic subnet creation using `count`
- Clean outputs for module composition

**Skills demonstrated:**
- Terraform module development
- DRY principles in IaC
- Reusable infrastructure components

## Technologies
- **IaC:** Terraform
- **Cloud:** AWS (VPC, EC2, NAT Gateway, IGW)
- **Version Control:** Git/GitHub

## Usage

Each project has its own README with deployment instructions.
```bash
cd vpc-module-project
terraform init
terraform plan
terraform apply

