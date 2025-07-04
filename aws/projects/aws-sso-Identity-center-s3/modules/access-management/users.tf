# SSO Users
resource "aws_identitystore_user" "users" {
  for_each = { for user in var.users : user.username => user }

  identity_store_id = var.identity_store_id

  user_name    = each.value.username
  display_name = "${each.value.first_name} ${each.value.last_name}"

  name {
    given_name  = each.value.first_name
    family_name = each.value.last_name
  }

  emails {
    value   = each.value.email
    primary = true
  }
}

# Group Memberships
resource "aws_identitystore_group_membership" "viewers" {
  for_each = {
    for user in var.users : user.username => user
    if contains(user.groups, "viewers")
  }

  identity_store_id = var.identity_store_id
  group_id          = aws_identitystore_group.viewers.group_id
  member_id         = aws_identitystore_user.users[each.key].user_id
}

resource "aws_identitystore_group_membership" "editors" {
  for_each = {
    for user in var.users : user.username => user
    if contains(user.groups, "editors")
  }

  identity_store_id = var.identity_store_id
  group_id          = aws_identitystore_group.editors.group_id
  member_id         = aws_identitystore_user.users[each.key].user_id
}

resource "aws_identitystore_group_membership" "admins" {
  for_each = {
    for user in var.users : user.username => user
    if contains(user.groups, "admins")
  }

  identity_store_id = var.identity_store_id
  group_id          = aws_identitystore_group.admins.group_id
  member_id         = aws_identitystore_user.users[each.key].user_id
}

resource "aws_identitystore_group_membership" "super_admins" {
  for_each = {
    for user in var.users : user.username => user
    if contains(user.groups, "super_admins")
  }

  identity_store_id = var.identity_store_id
  group_id          = aws_identitystore_group.super_admins.group_id
  member_id         = aws_identitystore_user.users[each.key].user_id
}
