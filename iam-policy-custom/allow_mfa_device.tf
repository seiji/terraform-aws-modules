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
      # "iam:ListUsers",
      "iam:ListVirtualMFADevices",
    ]
    effect = "Allow"
    resources = [
      "*",
    ]
  }
}

resource aws_iam_policy allow_mfa_device {
  name   = "allow-mfa-device"
  path   = "/"
  policy = data.aws_iam_policy_document.allow_mfa_device.json
}
