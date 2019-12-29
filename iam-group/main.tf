locals {
  group_policy = flatten([for k, v in var.groups : [for policy in v.policies : format("%s-%s", k, policy)]])
}

resource aws_iam_group this {
  for_each = var.groups

  name = each.key
  path = each.value.path
}

resource aws_iam_group_policy_attachment this {
  for_each = toset(local.group_policy)

  group      = split("-", each.value)[0]
  policy_arn = split("-", each.value)[1]

  depends_on = [aws_iam_group.this]
}
