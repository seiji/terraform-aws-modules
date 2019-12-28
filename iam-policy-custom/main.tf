locals {
  account_id = data.aws_caller_identity.current.account_id
}

data aws_caller_identity current {}

data aws_iam_policy_document allow_change_password {
  statement {
    actions   = ["iam:ChangePassword"]
    effect    = "Allow"
    resources = ["arn:aws:iam::${local.account_id}:user/&{aws:username}"]
  }

  statement {
    actions   = ["iam:GetAccountPasswordPolicy"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = ["iam:GetLoginProfile"]
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
    effect    = "Allow"
    resources = ["arn:aws:iam::${local.account_id}:user/&{aws:username}"]
  }
}
resource aws_iam_policy allow_change_passwod {
  name   = "AllowChangePassword"
  path   = "/"
  policy = data.aws_iam_policy_document.allow_change_password.json
}
