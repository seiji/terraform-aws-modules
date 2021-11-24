module "label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  stage     = var.stage
}

resource "aws_cloudwatch_log_group" "this" {
  name              = var.name
  retention_in_days = var.retention_in_days

  tags = module.label.tags
}
