module label {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  stage     = var.stage
}

resource aws_cloudwatch_log_subscription_filter this {
  name            = module.label.id
  log_group_name  = var.log_group_name
  filter_pattern  = ""
  destination_arn = var.destination_arn
  role_arn        = module.iam_role_logs.arn
  distribution    = "ByLogStream"
}

data aws_iam_policy_document firehose {
  statement {
    effect    = "Allow"
    actions   = ["firehose:*"]
    resources = [var.destination_arn]
  }
}

module iam_role_logs {
  source     = "../iam-role"
  name       = "${module.label.id}-logs"
  identifier = "logs.amazonaws.com"
  policy_json_list = [
    data.aws_iam_policy_document.firehose.json,
  ]
}

