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
