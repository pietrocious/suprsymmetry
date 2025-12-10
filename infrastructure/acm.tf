# acm certificate for pietrouni.com
resource "aws_acm_certificate" "pietrouni" {
  domain_name               = "pietrouni.com"
  subject_alternative_names = ["www.pietrouni.com"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "pietrouni-cert"
    Environment = "production"
  }
}

# dns validation records
resource "aws_route53_record" "pietrouni_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.pietrouni.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.pietrouni.zone_id
}

# wait for validation
resource "aws_acm_certificate_validation" "pietrouni" {
  certificate_arn         = aws_acm_certificate.pietrouni.arn
  validation_record_fqdns = [for record in aws_route53_record.pietrouni_cert_validation : record.fqdn]
}
