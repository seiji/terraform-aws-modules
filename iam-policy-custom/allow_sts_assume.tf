data aws_iam_policy_document allow_sts_assume {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]
    resources = [
      "arn:aws:ssm:*:*:session/assume-*",
    ]
  }
}

resource aws_iam_policy allow_sts_assume {
  name   = "allow-sts-assume"
  policy = data.aws_iam_policy_document.allow_sts_assume.json
}

