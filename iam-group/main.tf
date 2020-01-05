resource aws_iam_group this {
  name = var.name
  path = var.path
}

resource aws_iam_group_policy_attachment this {
  count = length(var.policies)

  group      = aws_iam_group.this.name
  policy_arn = var.policies[count.index]

  depends_on = [aws_iam_group.this]
}

resource aws_iam_group_membership this {
  name = "${var.name}-membership"

  group = aws_iam_group.this.name
  users = var.users

  depends_on = [aws_iam_group.this]
}
