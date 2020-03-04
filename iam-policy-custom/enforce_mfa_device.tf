data aws_iam_policy_document enforce_mfa_device {
  statement {
    effect = "Allow"
    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
    ]
    resources = [
      "arn:aws:iam::${local.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${local.account_id}:user/&{aws:username}",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "iam:DeactivateMFADevice",
    ]
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
    resources = [
      "arn:aws:iam::${local.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${local.account_id}:user/&{aws:username}",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "iam:DeleteVirtualMFADevice",
    ]
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
    resources = [
      "arn:aws:iam::${local.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${local.account_id}:user/&{aws:username}",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "iam:ListMFADevices",
      "iam:ListUsers",
      "iam:ListVirtualMFADevices",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Deny"
    not_actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:GetAccountPasswordPolicy",
      "iam:ListMFADevices",
      "iam:ListUsers",
      "iam:ListVirtualMFADevices",
      "iam:ResyncMFADevice",
    ]
    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false"]
    }
    resources = ["*"]
  }
}

resource aws_iam_policy enforce_mfa_device {
  name   = "enforce-mfa-device"
  path   = "/"
  policy = data.aws_iam_policy_document.enforce_mfa_device.json
}
