terraform {
  backend "s3" {
    bucket       = "terraform-states-vd"
    encrypt      = true
    key          = "aws/tasks/aws-instance/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Owner       = "Volodymyr Diadechko with ID"
      Project     = "Cybersecurity Project in ${var.region} region. Project: AWS Cloud and Terraform IaC"
      Environment = var.env
      Region      = "Region: ${var.region}"
    }
  }
}