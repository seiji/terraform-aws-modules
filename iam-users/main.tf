locals {
  users = { for u in var.users : u.name => u }
}
resource aws_iam_user this {
  for_each = local.users

  force_destroy = true
  name          = each.value.name
  path          = each.value.path

  provisioner "local-exec" {
    when    = destroy
    command = "sleep 60"
  }
}

resource aws_iam_user_group_membership this {
  for_each = local.users

  user   = each.value.name
  groups = each.value.groups

  depends_on = [aws_iam_user.this]
}
