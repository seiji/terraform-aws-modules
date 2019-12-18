data aws_iam_policy_document this {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.identifier]
    }
  }
}

resource aws_iam_role this {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.this.json
}

resource aws_iam_policy this {
  count       = length(var.policies)
  name_prefix = var.name
  policy      = var.policies[count.index]
}

resource aws_iam_role_policy_attachment this {
  count      = length(var.policies)
  role       = aws_iam_role.this.id
  policy_arn = aws_iam_policy.this[count.index].arn
}
