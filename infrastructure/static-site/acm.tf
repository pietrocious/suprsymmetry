# acm certificate for https
data "aws_acm_certificate" "website" {
  domain   = "suprsymmetry.com"
  statuses = ["ISSUED"]
}
