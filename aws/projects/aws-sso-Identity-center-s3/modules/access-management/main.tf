# Data sources
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# Identity Store (SSO) Groups
resource "aws_identitystore_group" "viewers" {
  identity_store_id = var.identity_store_id
  display_name      = "S3-Viewers"
  description       = "Users with read-only access to S3 website bucket"
}

resource "aws_identitystore_group" "editors" {
  identity_store_id = var.identity_store_id
  display_name      = "S3-Editors"
  description       = "Users with read and write access to S3 website bucket"
}

resource "aws_identitystore_group" "admins" {
  identity_store_id = var.identity_store_id
  display_name      = "S3-Admins"
  description       = "Users with full access to S3 website bucket"
}

resource "aws_identitystore_group" "super_admins" {
  identity_store_id = var.identity_store_id
  display_name      = "S3-SuperAdmins"
  description       = "Users with complete control over S3 website bucket"
}
