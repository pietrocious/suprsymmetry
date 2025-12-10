# route53 hosted zone for pietrouni.com
resource "aws_route53_zone" "pietrouni" {
  name = "pietrouni.com"

  tags = {
    Name        = "pietrouni-zone"
    Environment = "production"
  }
}

# root domain points to cloudfront
resource "aws_route53_record" "pietrouni_root" {
  zone_id = aws_route53_zone.pietrouni.zone_id
  name    = "pietrouni.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.pietrouni.domain_name
    zone_id                = aws_cloudfront_distribution.pietrouni.hosted_zone_id
    evaluate_target_health = false
  }
}

# www subdomain points to cloudfront
resource "aws_route53_record" "pietrouni_www" {
  zone_id = aws_route53_zone.pietrouni.zone_id
  name    = "www.pietrouni.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.pietrouni.domain_name
    zone_id                = aws_cloudfront_distribution.pietrouni.hosted_zone_id
    evaluate_target_health = false
  }
}
