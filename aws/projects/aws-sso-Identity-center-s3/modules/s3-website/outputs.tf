output "region" {
  value = var.region
}

output "account_id" {
  value = var.account_id
}

output "bucket_name" {
  description = "The name of the main S3 bucket"
  value       = aws_s3_bucket.main.bucket
}

output "bucket_arn" {
  description = "The ARN of the main S3 bucket"
  value       = aws_s3_bucket.main.arn
}

output "bucket_website_endpoint" {
  description = "The website endpoint of the main S3 bucket"
  value       = aws_s3_bucket_website_configuration.main.website_endpoint
}

output "bucket_website_domain" {
  description = "The website domain of the main S3 bucket"
  value       = aws_s3_bucket_website_configuration.main.website_domain
}

output "redirect_bucket_name" {
  description = "The name of the redirect S3 bucket"
  value       = aws_s3_bucket.redirect.bucket
}

output "redirect_bucket_arn" {
  description = "The ARN of the redirect S3 bucket"
  value       = aws_s3_bucket.redirect.arn
}

output "redirect_bucket_website_endpoint" {
  description = "The website endpoint of the redirect S3 bucket"
  value       = aws_s3_bucket_website_configuration.redirect.website_endpoint
}

output "redirect_bucket_website_domain" {
  description = "The website domain of the redirect S3 bucket"
  value       = aws_s3_bucket_website_configuration.redirect.website_domain
}

output "website_url" {
  description = "The main website URL"
  value       = "http://${aws_s3_bucket_website_configuration.main.website_endpoint}"
}

output "www_website_url" {
  description = "The www website URL (redirects to main)"
  value       = "http://${aws_s3_bucket_website_configuration.redirect.website_endpoint}"
}

# CloudFront outputs
output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.id
}

output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.arn
}

# Domain outputs
output "main_domain_name" {
  description = "The main domain name for the website"
  value       = "s3.${var.hosted_zone}"
}

output "www_domain_name" {
  description = "The www domain name for the website"
  value       = "www.s3.${var.hosted_zone}"
}

output "https_main_url" {
  description = "The HTTPS URL for the main domain"
  value       = "https://s3.${var.hosted_zone}"
}

output "https_www_url" {
  description = "The HTTPS URL for the www domain"
  value       = "https://www.s3.${var.hosted_zone}"
}

# Certificate outputs
output "certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = aws_acm_certificate.domain_cert.arn
}

output "certificate_domain_name" {
  description = "The domain name of the certificate"
  value       = aws_acm_certificate.domain_cert.domain_name
}
