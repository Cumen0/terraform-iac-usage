output "region" {
  description = "AWS region"
  value       = var.region
}

output "account_id" {
  description = "AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "project_name" {
  description = "Project name"
  value       = var.project_name
}

output "environment" {
  description = "Environment name"
  value       = var.env
}

# S3 Website outputs
output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3_website.bucket_name
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3_website.bucket_arn
}

output "website_endpoint" {
  description = "Website endpoint URL"
  value       = module.s3_website.bucket_website_endpoint
}

output "website_domain" {
  description = "Website domain name"
  value       = module.s3_website.bucket_website_domain
}

# CloudFront outputs
output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.s3_website.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.s3_website.cloudfront_domain_name
}

# Domain outputs
output "main_domain_name" {
  description = "Main domain name for the website"
  value       = module.s3_website.main_domain_name
}

output "www_domain_name" {
  description = "WWW domain name for the website"
  value       = module.s3_website.www_domain_name
}

output "https_main_url" {
  description = "HTTPS URL for the main domain"
  value       = module.s3_website.https_main_url
}

output "https_www_url" {
  description = "HTTPS URL for the www domain"
  value       = module.s3_website.https_www_url
}

# Certificate outputs
output "certificate_arn" {
  description = "ACM certificate ARN"
  value       = module.s3_website.certificate_arn
}

output "certificate_domain_name" {
  description = "Certificate domain name"
  value       = module.s3_website.certificate_domain_name
}

# RBAC outputs
output "viewer_group_id" {
  description = "ID of the Viewers group"
  value       = module.access-management.viewer_group_id
}

output "editor_group_id" {
  description = "ID of the Editors group"
  value       = module.access-management.editor_group_id
}

output "admin_group_id" {
  description = "ID of the Admins group"
  value       = module.access-management.admin_group_id
}

output "super_admin_group_id" {
  description = "ID of the Super Admins group"
  value       = module.access-management.super_admin_group_id
}

output "user_ids" {
  description = "Map of usernames to user IDs"
  value       = module.access-management.user_ids
}
