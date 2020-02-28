locals {
  account_id = data.aws_caller_identity.current.account_id
}

data aws_caller_identity current {}

data aws_iam_policy_document allow_change_password {
  statement {
    actions = [
      "iam:ChangePassword"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:iam::${local.account_id}:user/&{aws:username}"
    ]
  }
  statement {
    actions = [
      "iam:GetAccountPasswordPolicy"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "iam:GetLoginProfile"
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

resource aws_iam_policy allow_change_password {
  name   = "AllowChangePassword"
  path   = "/"
  policy = data.aws_iam_policy_document.allow_change_password.json
}

data aws_iam_policy_document allow_mfa_device {
  statement {
    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
    ]
    effect = "Allow"
    resources = [
      "arn:aws:iam::${local.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${local.account_id}:user/&{aws:username}",
    ]
  }
  statement {
    actions = [
      "iam:DeactivateMFADevice",
    ]
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
    effect = "Allow"
    resources = [
      "arn:aws:iam::${local.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${local.account_id}:user/&{aws:username}",
    ]
  }
  statement {
    actions = [
      "iam:DeleteVirtualMFADevice",
    ]
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
    effect = "Allow"
    resources = [
      "arn:aws:iam::${local.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${local.account_id}:user/&{aws:username}",
    ]
  }
  statement {
    actions = [
      "iam:ListMFADevices",
      "iam:ListUsers",
      "iam:ListVirtualMFADevices",
    ]
    effect = "Allow"
    resources = [
      "*",
    ]
  }
}

resource aws_iam_policy allow_mfa_device {
  name   = "AllowMFADevice"
  path   = "/"
  policy = data.aws_iam_policy_document.allow_mfa_device.json
}

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
  name   = "AllowAccessKey"
  path   = "/"
  policy = data.aws_iam_policy_document.allow_access_key.json
}
