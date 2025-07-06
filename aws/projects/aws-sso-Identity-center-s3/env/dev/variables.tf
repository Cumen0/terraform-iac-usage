variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod", "test"], var.env)
    error_message = "Environment must be one of: dev, staging, prod, test."
  }
}

variable "project_name" {
  description = "The name of the project (used in resource naming and tagging)"
  type        = string
  default     = "sso-bucket-website"
}

variable "identity_store_id" {
  description = "Identity Store ID for SSO"
  type        = string
}

variable "sso_instance_arn" {
  description = "SSO Instance ARN"
  type        = string
}

variable "hosted_zone" {
  description = "The Route 53 hosted zone ID for the S3 website"
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
  default = [
    {
      username   = "alice"
      email      = "alice@example.com"
      first_name = "Alice"
      last_name  = "Johnson"
      groups     = ["viewers"]
    },
    {
      username   = "bob"
      email      = "bob@example.com"
      first_name = "Bob"
      last_name  = "Smith"
      groups     = ["editors"]
    },
    {
      username   = "charlie"
      email      = "charlie@example.com"
      first_name = "Charlie"
      last_name  = "Brown"
      groups     = ["admins"]
    },
    {
      username   = "diana"
      email      = "diana@example.com"
      first_name = "Diana"
      last_name  = "Wilson"
      groups     = ["super_admins"]
    }
  ]
}