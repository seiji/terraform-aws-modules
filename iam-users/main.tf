resource aws_iam_user this {
  for_each = var.users

  name = each.key
  path = each.value.path
}
