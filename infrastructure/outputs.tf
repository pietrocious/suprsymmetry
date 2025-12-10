output "website_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.website.id
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.website.id
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "route53_nameservers" {
  description = "Route53 nameservers to configure in domain registrar"
  value       = aws_route53_zone.main.name_servers
}

output "website_url" {
  description = "Website URL"
  value       = "https://suprsymmetry.com"
}

# pietrouni.com outputs
output "pietrouni_bucket_name" {
  description = "Name of the pietrouni S3 bucket"
  value       = aws_s3_bucket.pietrouni.id
}

output "pietrouni_cloudfront_distribution_id" {
  description = "CloudFront distribution ID for pietrouni"
  value       = aws_cloudfront_distribution.pietrouni.id
}

output "pietrouni_cloudfront_domain_name" {
  description = "CloudFront distribution domain name for pietrouni"
  value       = aws_cloudfront_distribution.pietrouni.domain_name
}

output "pietrouni_nameservers" {
  description = "Route53 nameservers to configure in Hover for pietrouni.com"
  value       = aws_route53_zone.pietrouni.name_servers
}

output "pietrouni_website_url" {
  description = "Website URL for pietrouni"
  value       = "https://pietrouni.com"
}
