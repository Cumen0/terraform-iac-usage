# Development Environment Setup

This directory contains the Terraform configuration for the development environment.

## Configuration

### Option 1: Using terraform.tfvars (Recommended for local development)

1. Copy the example file:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your actual values:
   ```hcl
   identity_store_id = "d-90663bc3aa"
   sso_instance_arn  = "arn:aws:sso:::instance/ssoins-7223dc6b0b831694"
   hosted_zone       = "your-domain.com"
   ```

### Option 2: Using Environment Variables (Recommended for CI/CD)

Set the following environment variables:

```bash
export TF_VAR_identity_store_id="d-90663bc3aa"
export TF_VAR_sso_instance_arn="arn:aws:sso:::instance/ssoins-7223dc6b0b831694"
export TF_VAR_hosted_zone="your-domain.com"
```

### Option 3: Using Command Line Arguments

```bash
terraform plan \
  -var="identity_store_id=d-90663bc3aa" \
  -var="sso_instance_arn=arn:aws:sso:::instance/ssoins-7223dc6b0b831694" \
  -var="hosted_zone=your-domain.com"
```

## Security Notes

- The `terraform.tfvars` file is ignored by Git for security reasons
- Use environment variables in CI/CD pipelines
- Never commit sensitive values to version control
- Use AWS Secrets Manager or Parameter Store for production environments

## Getting Required Values

### Identity Store ID

1. Go to AWS SSO Console
2. Navigate to Settings
3. Copy the Identity Store ID

### SSO Instance ARN

1. Go to AWS SSO Console
2. Navigate to Settings
3. Copy the SSO Instance ARN

### Hosted Zone

Use your Route 53 hosted zone domain name (e.g., "example.com")
