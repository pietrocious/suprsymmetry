# origin access control restricts s3 to cloudfront only
resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "suprsymmetry-oac"
  description                       = "OAC for suprsymmetry.com S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# cloudfront function to rewrite /resume -> /resume.html
resource "aws_cloudfront_function" "resume_rewrite" {
  name    = "resume-url-rewrite"
  runtime = "cloudfront-js-1.0"
  comment = "Rewrite /resume to /resume.html"
  publish = true
  code    = <<-EOT
    function handler(event) {
      var request = event.request;
      var uri = request.uri;
      
      if (uri === '/resume' || uri === '/resume/') {
        request.uri = '/resume.html';
      }
      
      return request;
    }
  EOT
}

# cloudfront distribution with custom domain
resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = ["suprsymmetry.com", "www.suprsymmetry.com"]

  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id                = "S3-suprsymmetry"
    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

  # default behavior for landing page
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-suprsymmetry"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  # ordered cache behavior for /resume route
  ordered_cache_behavior {
    path_pattern     = "/resume"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-suprsymmetry"

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

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.resume_rewrite.arn
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.website.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = "suprsymmetry-cdn"
    Environment = "production"
  }
}
