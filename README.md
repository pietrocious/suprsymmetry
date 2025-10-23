# production aws infrastructure

production-grade aws infrastructure with auto-scaling, automated monitoring, and infrastructure-as-code using terraform.

posting updates & soon video walk-through :)

## capabilities

**week 1: vpc networking & ci/cd**
* custom vpc with public/private subnets across multiple availability zones
* reusable terraform modules for infrastructure components
* github actions ci/cd pipeline for automated validation on every commit
* secure aws credential management via github secrets

**week 2: auto-scaling infrastructure** *(current)*
* application load balancer distributing traffic across multiple availability zones
* auto scaling groups with cpu-based scaling policies (scales 2-4 instances)
* cloudwatch monitoring with sns alerts on high/low cpu and unhealthy targets
* automated failover and self-healing infrastructure

## tech stack

* **infrastructure:** aws (vpc, ec2, alb, asg, cloudwatch, sns)
* **iac:** terraform with reusable modules
* **ci/cd:** github actions for automated validation
* **monitoring:** cloudwatch metrics and alarms

## architecture info

multi-az vpc with public/private subnets, internet gateway, and route tables. alb in public subnets distributes traffic to asg instances that automatically scale based on cpu utilization.

## monitoring *(in progress)*

cloudwatch alarms configured for:
* high cpu (>15%) → triggers scale-up
* low cpu (<30%) → triggers scale-down
* unhealthy targets → immediate sns notification

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

## todo

* [x] week 1: vpc networking and ci/cd foundation
* [x] week 2: auto-scaling infrastructure with monitoring
* [ ] week 3: static website deployment (s3, cloudfront, route53)
* [ ] week 4: container orchestration with eks
* [ ] week 5: remote state management and multi-environment
* [ ] week 6: security hardening and compliance
