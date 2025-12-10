# s3 bucket for pietrouni static website
resource "aws_s3_bucket" "pietrouni" {
  bucket = "pietrouni.com"

  tags = {
    Name        = "pietrouni-website"
    Environment = "production"
  }
}

# block public access except via cloudfront
resource "aws_s3_bucket_public_access_block" "pietrouni" {
  bucket = aws_s3_bucket.pietrouni.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
}

# bucket policy allows cloudfront access via oac
resource "aws_s3_bucket_policy" "pietrouni" {
  bucket = aws_s3_bucket.pietrouni.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.pietrouni.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.pietrouni.arn
          }
        }
      }
    ]
  })
}
