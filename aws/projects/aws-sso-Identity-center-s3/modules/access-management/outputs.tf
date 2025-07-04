# Group outputs
output "viewer_group_id" {
  description = "ID of the Viewers group"
  value       = aws_identitystore_group.viewers.group_id
}

output "editor_group_id" {
  description = "ID of the Editors group"
  value       = aws_identitystore_group.editors.group_id
}

output "admin_group_id" {
  description = "ID of the Admins group"
  value       = aws_identitystore_group.admins.group_id
}

output "super_admin_group_id" {
  description = "ID of the Super Admins group"
  value       = aws_identitystore_group.super_admins.group_id
}

# User outputs
output "user_ids" {
  description = "Map of usernames to user IDs"
  value       = { for k, v in aws_identitystore_user.users : k => v.user_id }
}

# Permission Set outputs
output "viewer_permission_set_arn" {
  description = "ARN of the Viewer permission set"
  value       = aws_ssoadmin_permission_set.viewer_permission_set.arn
}

output "editor_permission_set_arn" {
  description = "ARN of the Editor permission set"
  value       = aws_ssoadmin_permission_set.editor_permission_set.arn
}

output "admin_permission_set_arn" {
  description = "ARN of the Admin permission set"
  value       = aws_ssoadmin_permission_set.admin_permission_set.arn
}

output "super_admin_permission_set_arn" {
  description = "ARN of the Super Admin permission set"
  value       = aws_ssoadmin_permission_set.super_admin_permission_set.arn
}
