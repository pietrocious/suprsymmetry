# route53 hosted zone
resource "aws_route53_zone" "main" {
  name = "suprsymmetry.com"

  tags = {
    Name        = "suprsymmetry-zone"
    Environment = "production"
  }
}

# root domain points to cloudfront
resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "suprsymmetry.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

# www subdomain points to cloudfront
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.suprsymmetry.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}
