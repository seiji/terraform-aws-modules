resource "aws_iam_group" "this" {
  for_each = var.groups
  name     = each.key
  path     = var.group_path
}

resource "aws_iam_group_policy_attachment" "this" {
  for_each = { for item in flatten([
    for n, policy_arns in var.groups : [
      for p in policy_arns : {
        "${n}-${p}" = {
          name       = n
          policy_arn = p
        }
      }
    ]
    ]) :
    keys(item)[0] => values(item)[0]
  }
  group      = aws_iam_group.this[each.value.name].name
  policy_arn = each.value.policy_arn
  depends_on = [aws_iam_group.this]
}

resource "aws_iam_user" "this" {
  for_each      = var.users
  force_destroy = true
  name          = each.key
  path          = var.user_path

  provisioner "local-exec" {
    when    = destroy
    command = "sleep 60"
  }
}

resource "aws_iam_user_group_membership" "this" {
  for_each = var.users
  user     = each.key
  groups = [for n in each.value :
    aws_iam_group.this[n].name
  ]
  depends_on = [aws_iam_user.this, aws_iam_group.this]
}
