module label {
  source     = "../../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

data aws_iam_policy_document this {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
    principals {
      type        = var.principals.type
      identifiers = var.principals.identifiers
    }
  }
}

resource aws_iam_role this {
  name               = module.label.id
  path               = var.path
  assume_role_policy = data.aws_iam_policy_document.this.json
  depends_on         = [data.aws_iam_policy_document.this]
}

resource aws_iam_role_policy inline {
  count      = length(var.policy_json_list)
  role       = aws_iam_role.this.id
  policy     = var.policy_json_list[count.index]
  depends_on = [aws_iam_role.this]
}

resource aws_iam_role_policy_attachment arn {
  count      = length(var.policy_arn_list)
  role       = aws_iam_role.this.id
  policy_arn = var.policy_arn_list[count.index]
  depends_on = [aws_iam_role.this]
}
