terraform {
  backend "s3" {
    bucket       = "terraform-states-vd"
    key          = "sso-s3/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Owner       = "Volodymyr Diadecko with ID"
      Project     = "SSO Cybersecurity Project. Project: AWS Cloud and Terraform IaC"
      Environment = var.env
      Region      = "Region: ${var.region}"
      ManagedBy   = "Terraform"
    }
  }
}

module "s3_website" {
  source         = "../../modules/s3-website"
  region         = var.region
  env            = var.env
  account_id     = data.aws_caller_identity.current.account_id
  project_name   = var.project_name
  hosted_zone    = data.aws_route53_zone.hosted_zone.name
  hosted_zone_id = data.aws_route53_zone.hosted_zone.zone_id
}

module "access-management" {
  source       = "../../modules/access-management"
  region       = var.region
  env          = var.env
  account_id   = data.aws_caller_identity.current.account_id
  project_name = var.project_name

  identity_store_id = var.identity_store_id
  sso_instance_arn  = var.sso_instance_arn
  users             = var.users
  s3_bucket_name    = module.s3_website.bucket_name
  s3_bucket_arn     = module.s3_website.bucket_arn

  depends_on = [
    module.s3_website
  ]
}
