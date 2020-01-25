module label {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  stage     = var.stage
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "root" {
  statement {
    sid       = "Enable IAM User Permissions"
    actions   = ["kms:*"]
    resources = ["*"]
    effect    = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
  statement {
    sid = "Allow use of the key"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = ["*"]
    effect    = "Allow"

    principals {
      type        = "AWS"
      identifiers = [var.role_arn]
    }
  }
  statement {
    sid = "Allow attachment of persistent resources"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
    ]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"

      values = [
        true
      ]
    }
    resources = ["*"]
    effect    = "Allow"

    principals {
      type        = "AWS"
      identifiers = [var.role_arn]
    }
  }
}

resource "aws_kms_key" "this" {
  key_usage = "ENCRYPT_DECRYPT"
  policy    = data.aws_iam_policy_document.root.json
  tags      = module.label.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/${module.label.id}"
  target_key_id = aws_kms_key.this.key_id
}
