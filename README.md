# AWS infrastructure for a personal portfolio site

**personal portfolio:** [suprsymmetry.com](https://suprsymmetry.com)

this is a production-grade cloud infrastructure designed to test devops engineering capabilities through infrastructure-as-code, automated monitoring, and modern deployment practices.

in physics, supersymmetry describes universal balance through particle partnerships. in infrastructure, we build that balance through architectural patterns.

like its namesake, this project showcases symmetry and resilience across distributed systems: multi-az redundancy, auto-scaling compute, and globally distributed content delivery. 

built using [terraform ](https://github.com/hashicorp/terraform)

posting updates & soon video walk-through :)

---

## project overview

this repository showcases a complete aws infrastructure built with terraform, featuring multi-az networking, auto-scaling compute resources, global content delivery, and monitoring. 

designed to demonstrate practical devops skills applicable to enterprise environments

## architecture

### composed of:

**networking foundation**
- custom vpc with public/private subnets across multiple availability zones
- internet gateway for public internet access
- route tables and security groups following least-privilege principles
- designed for high availability and fault tolerance

**auto-scaling compute layer**
- application load balancer distributing traffic across multiple azs
- auto scaling groups with cpu-based scaling policies (2-4 instances)
- health checks and automated failover for self-healing infrastructure
- cloudwatch monitoring with sns alerts on high/low cpu and unhealthy targets

**static site hosting**
- s3 bucket with cloudfront cdn for global content delivery
- Route53 DNS management with custom domain
- ACM TLS/SSL certificates for https encryption
- origin access control (OAC) restricting s3 access to cloudfront only
- secure architecture preventing direct s3 access while enabling fast global delivery

### tech stack

**infrastructure**
- AWS: vpc, ec2, alb, asg, s3, cloudfront, route53, acm, cloudwatch, sns
- terraform: infrastructure as code with reusable modules
- github actions: automated validation on every commit

**devops practices**
- infrastructure as code (iac) for reproducibility
- modular design for reusability across environments
- automated monitoring and alerting
- security-first architecture (least privilege, encrypted traffic, restricted access)
- cost optimization (destroy unused resources, leverage free tier)

### structure
```
infrastructure/
├── networking/         # vpc foundation and network configuration
├── compute/            # auto-scaling infrastructure with monitoring
├── static-site/        # s3 + cloudfront + route53 configuration
│   └── website/        # static website content
└── modules/
    └── vpc/            # reusable vpc terraform module

docs/                   # architecture documentation and reference configs
archive/                # early experiments and learning iterations
.github/workflows/      # ci/cd pipeline for terraform validation
```

---

## deployment

### prerequisites
- aws account and ec2 instance
- terraform >= 1.13.3

### deploy infrastructure
```bash
# networking layer
cd infrastructure/networking
terraform init
terraform apply

# compute layer (requires networking)
cd ../compute
terraform init
terraform apply

# static site
cd ../static-site
terraform init
terraform apply
```

---

## monitoring

cloudwatch alarms configured for:
- **high_cpu (>15%)** → triggers scale-up to handle increased load
- **low_cpu (<30%)** → triggers scale-down to reduce costs
- **unhealthy_targets** → immediate sns email notification

auto-scaling policies automatically adjust capacity based on demand, ensuring application remains responsive while optimizing costs

---

## security features

- **network isolation:** public/private subnet separation with security groups
- **encryption in transit:** https enforced via cloudfront with acm certificates
- **least privilege access:** iam policies and security groups limit access scope
- **origin access control:** s3 bucket only accessible through cloudfront distribution
- **automated security updates:** instances configured to pull latest security patches

---

## future enhancements

- container orchestration with eks
- remote state management with s3 backend and dynamodb locking
- multi-environment setup (dev/staging/prod)
- automated testing and deployment pipeline
- infrastructure cost tracking and optimization dashboards
- security hardening and compliance automation

---

## special thanks

- adrian cantrill's [SAA course] (https://learn.cantrill.io/p/aws-certified-solutions-architect-associate-saa-c03)
- logan marchione's [best devops project for a beginner] (https://loganmarchione.com/2022/10/the-best-devops-project-for-a-beginner/)
- [r/devops] (https://www.reddit.com/r/devops/?rdt=63211)

## contact

- linkedin: [in/pietrouni](https://linkedin.com/in/pietrouni)
