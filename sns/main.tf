module label {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  attributes = var.attributes
}

data aws_caller_identity this {}

data aws_iam_policy_document this {
  policy_id = "__default_policy_ID"

  statement {
    effect = "Allow"
    sid    = "__default_statement_ID"
    actions = [
      "SNS:AddPermission",
      "SNS:DeleteTopic",
      "SNS:GetTopicAttributes",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive",
      "SNS:RemovePermission",
      "SNS:SetTopicAttributes",
      "SNS:Subscribe",
    ]
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.this.account_id]
      variable = "AWS:SourceOwner"
    }
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    resources = [aws_sns_topic.this.arn]
  }
}

resource aws_sns_topic this {
  name         = module.label.id
  display_name = module.label.id

  tags = module.label.tags
}

resource aws_sns_topic_policy this {
  arn    = aws_sns_topic.this.arn
  policy = data.aws_iam_policy_document.this.json
}
