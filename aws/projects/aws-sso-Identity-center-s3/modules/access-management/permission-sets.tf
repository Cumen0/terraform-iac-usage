# AWS SSO Permission Sets

# Permission Set for Viewers
resource "aws_ssoadmin_permission_set" "viewer_permission_set" {
  name             = "sso-s3-viewer"
  description      = "Permission set for S3 viewers"
  instance_arn     = var.sso_instance_arn
  session_duration = "PT1H" # 1 hour
}

# Permission Set for Editors
resource "aws_ssoadmin_permission_set" "editor_permission_set" {
  name             = "sso-s3-editor"
  description      = "Permission set for S3 editors"
  instance_arn     = var.sso_instance_arn
  session_duration = "PT1H" # 1 hour
}

# Permission Set for Admins
resource "aws_ssoadmin_permission_set" "admin_permission_set" {
  name             = "sso-s3-admin"
  description      = "Permission set for S3 admins"
  instance_arn     = var.sso_instance_arn
  session_duration = "PT1H" # 1 hour
}

# Permission Set for Super Admins
resource "aws_ssoadmin_permission_set" "super_admin_permission_set" {
  name             = "sso-s3-super-admin"
  description      = "Permission set for S3 super admins"
  instance_arn     = var.sso_instance_arn
  session_duration = "PT1H" # 1 hour
}

# Inline Policies for Permission Sets

# Viewer Policy
resource "aws_ssoadmin_permission_set_inline_policy" "viewer_policy" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.viewer_permission_set.arn

  inline_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

# Editor Policy
resource "aws_ssoadmin_permission_set_inline_policy" "editor_policy" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.editor_permission_set.arn

  inline_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

# Admin Policy
resource "aws_ssoadmin_permission_set_inline_policy" "admin_policy" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin_permission_set.arn

  inline_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

# Super Admin Policy
resource "aws_ssoadmin_permission_set_inline_policy" "super_admin_policy" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.super_admin_permission_set.arn

  inline_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:DeleteBucket",
          "s3:PutBucketPolicy",
          "s3:DeleteBucketPolicy",
          "s3:PutBucketVersioning",
          "s3:PutBucketAcl",
          "s3:PutBucketCors",
          "s3:PutBucketLogging",
          "s3:PutBucketNotification",
          "s3:PutBucketRequestPayment",
          "s3:PutBucketTagging",
          "s3:PutBucketWebsite"
        ]
        Resource = var.s3_bucket_arn
      }
    ]
  })
}

# Account Assignments

# Assign Viewer Permission Set to Viewers Group
resource "aws_ssoadmin_account_assignment" "viewer_assignment" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.viewer_permission_set.arn

  principal_id   = aws_identitystore_group.viewers.group_id
  principal_type = "GROUP"

  target_id   = var.account_id
  target_type = "AWS_ACCOUNT"
}

# Assign Editor Permission Set to Editors Group
resource "aws_ssoadmin_account_assignment" "editor_assignment" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.editor_permission_set.arn

  principal_id   = aws_identitystore_group.editors.group_id
  principal_type = "GROUP"

  target_id   = var.account_id
  target_type = "AWS_ACCOUNT"
}

# Assign Admin Permission Set to Admins Group
resource "aws_ssoadmin_account_assignment" "admin_assignment" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin_permission_set.arn

  principal_id   = aws_identitystore_group.admins.group_id
  principal_type = "GROUP"

  target_id   = var.account_id
  target_type = "AWS_ACCOUNT"
}

# Assign Super Admin Permission Set to Super Admins Group
resource "aws_ssoadmin_account_assignment" "super_admin_assignment" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.super_admin_permission_set.arn

  principal_id   = aws_identitystore_group.super_admins.group_id
  principal_type = "GROUP"

  target_id   = var.account_id
  target_type = "AWS_ACCOUNT"
}
