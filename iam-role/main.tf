data aws_iam_policy_document this {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]
    principals {
      type        = var.principals.type
      identifiers = var.principals.identifiers
    }
  }
}

resource aws_iam_role this {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.this.json

  depends_on = [data.aws_iam_policy_document.this]
}

resource aws_iam_policy json {
  count       = length(var.policy_json_list)
  name_prefix = var.name
  policy      = var.policy_json_list[count.index]
}

resource aws_iam_role_policy_attachment json {
  count      = length(var.policy_json_list)
  role       = aws_iam_role.this.id
  policy_arn = aws_iam_policy.json[count.index].arn

  depends_on = [
    aws_iam_role.this,
    aws_iam_policy.json,
  ]
}

resource aws_iam_role_policy_attachment arn {
  count      = length(var.policy_arns)
  role       = aws_iam_role.this.id
  policy_arn = var.policy_arns[count.index]

  depends_on = [
    aws_iam_role.this,
  ]
}
