# Upload website files to S3 bucket
resource "aws_s3_object" "website_files" {
  for_each = fileset("${path.module}/src", "*.html")

  bucket       = aws_s3_bucket.main.id
  key          = each.value
  source       = "${path.module}/src/${each.value}"
  content_type = "text/html"
  etag         = filemd5("${path.module}/src/${each.value}")

  tags = {
    Name        = "Website File: ${each.value}"
    Environment = var.env
    Project     = "${title(var.project_name)} Application"
    ManagedBy   = "Terraform"
  }
}

# Upload any additional static assets (CSS, JS, images, etc.)
resource "aws_s3_object" "static_assets" {
  for_each = fileset("${path.module}/src", "*.{css,js,png,jpg,jpeg,gif,ico,svg}")

  bucket = aws_s3_bucket.main.id
  key    = each.value
  source = "${path.module}/src/${each.value}"
  content_type = lookup({
    "css"  = "text/css"
    "js"   = "application/javascript"
    "png"  = "image/png"
    "jpg"  = "image/jpeg"
    "jpeg" = "image/jpeg"
    "gif"  = "image/gif"
    "ico"  = "image/x-icon"
    "svg"  = "image/svg+xml"
  }, split(".", each.value)[1], "application/octet-stream")
  etag = filemd5("${path.module}/src/${each.value}")

  tags = {
    Name        = "Static Asset: ${each.value}"
    Environment = var.env
    Project     = "${title(var.project_name)} Application"
    ManagedBy   = "Terraform"
  }
}
