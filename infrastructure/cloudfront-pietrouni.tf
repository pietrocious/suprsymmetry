# origin access control for pietrouni
resource "aws_cloudfront_origin_access_control" "pietrouni" {
  name                              = "pietrouni-oac"
  description                       = "OAC for pietrouni.com S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# cloudfront distribution for pietrouni
resource "aws_cloudfront_distribution" "pietrouni" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = ["pietrouni.com", "www.pietrouni.com"]

  origin {
    domain_name              = aws_s3_bucket.pietrouni.bucket_regional_domain_name
    origin_id                = "S3-pietrouni"
    origin_access_control_id = aws_cloudfront_origin_access_control.pietrouni.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-pietrouni"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.pietrouni.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = "pietrouni-cdn"
    Environment = "production"
  }
}
