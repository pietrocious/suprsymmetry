output "vpc_id" {
  description = "VPC ID from module"
  value       = module.dev_vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.dev_vpc.public_subnet_ids
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.dev_vpc.private_subnet_ids
}
