module label {
  source    = "../label"
  namespace = var.namespace
  stage     = var.stage
}

resource aws_lambda_layer_version this {
  layer_name       = module.label.id
  filename         = var.layer.filename
  source_code_hash = var.layer.source_code_hash
}

resource aws_lambda_function this {
  function_name    = module.label.id
  handler          = var.function.handler
  filename         = var.function.filename
  runtime          = "python3.6"
  role             = module.iam_role_lambda.arn
  source_code_hash = var.function.source_code_hash
  layers           = [aws_lambda_layer_version.this.arn]

  tags = module.label.tags
}

module iam_role_lambda {
  source = "../iam-role"
  name   = module.label.id
  principals = {
    type        = "Service"
    identifiers = ["lambda.amazonaws.com"]
  }
  policy_json_list = [
    data.aws_iam_policy_document.allow_logs.json,
  ]
}

data aws_iam_policy_document allow_logs {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}
