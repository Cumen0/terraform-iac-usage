data "aws_caller_identity" "current" {}
data "aws_route53_zone" "hosted_zone" {
  name = var.hosted_zone
}
