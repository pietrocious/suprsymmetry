# s3 bucket for static website
resource "aws_s3_bucket" "website" {
  bucket = "suprsymmetry.com"

  tags = {
    Name        = "suprsymmetry-website"
    Environment = "production"
  }
}

# block public access except via cloudfront
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false  # allow bucket policy for cloudfront
  restrict_public_buckets = false  # allow bucket policy for cloudfront
}

# bucket policy allows cloudfront access via oac
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

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
        Resource = "${aws_s3_bucket.website.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.website.arn
          }
        }
      }
    ]
  })
}

# desktop landing page
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  source       = "${path.module}/site/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/site/index.html")
}

# resume page @ /resume
resource "aws_s3_object" "resume" {
  bucket       = aws_s3_bucket.website.id
  key          = "resume.html"
  source       = "${path.module}/site/resume.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/site/resume.html")
}