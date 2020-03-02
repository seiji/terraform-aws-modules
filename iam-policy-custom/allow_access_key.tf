data aws_iam_policy_document allow_access_key {
  statement {
    actions = [
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:GetAccessKeyLastUsed",
      "iam:GetUser",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey",
    ]
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
    effect = "Allow"
    resources = [
      "arn:aws:iam::${local.account_id}:user/&{aws:username}"
    ]
  }
}

resource aws_iam_policy allow_access_key {
  name   = "allow-access-key"
  path   = "/"
  policy = data.aws_iam_policy_document.allow_access_key.json
}

