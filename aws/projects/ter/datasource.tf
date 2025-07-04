data "aws_caller_identity" "current" {}
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

data "aws_route53_zone" "hosted_zone" {
  name = var.hosted_zone_name
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "subnets" {}
