data "aws_caller_identity" "this" {}

data "aws_iam_policy_document" "this" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        data.aws_caller_identity.this.account_id
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.this.arn,
    ]

    sid = "__default_statement_ID"
  }
}

resource "aws_sns_topic" "this" {
  name         = var.name
  display_name = var.display_name
}

resource "aws_sns_topic_policy" "this" {
  arn = aws_sns_topic.this.arn

  policy = data.aws_iam_policy_document.this.json
}
