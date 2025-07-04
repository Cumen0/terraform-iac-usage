variable "region" {
  description = "AWS region"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "identity_store_id" {
  description = "Identity Store ID for SSO"
  type        = string
}

variable "sso_instance_arn" {
  description = "SSO Instance ARN"
  type        = string
}

variable "users" {
  description = "List of users to be created in SSO"
  type = list(object({
    username   = string
    email      = string
    first_name = string
    last_name  = string
    groups     = list(string)
  }))
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket ARN"
  type        = string
}
