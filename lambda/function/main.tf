module "label" {
  source    = "../../label"
  namespace = var.namespace
  stage     = var.stage
}

module "iam_role_lambda" {
  source = "../../iam-role"
  name   = module.label.id
  principals = {
    type        = "Service"
    identifiers = ["lambda.amazonaws.com"]
  }
  policy_json_list = var.role_policy.policy_jsons
  policy_arns      = var.role_policy.policy_arns
}

resource "aws_lambda_function" "this" {
  function_name    = module.label.id
  handler          = var.handler
  filename         = var.filename
  runtime          = var.runtime
  role             = module.iam_role_lambda.arn
  source_code_hash = var.source_code_hash
  layers           = var.layers

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      subnet_ids         = vpc_config.value.subnet_ids
      security_group_ids = vpc_config.value.security_group_ids
    }
  }
  dynamic "environment" {
    for_each = var.environment != null ? [var.environment] : []
    content {
      variables = environment.value
    }
  }
  tags = module.label.tags
}

