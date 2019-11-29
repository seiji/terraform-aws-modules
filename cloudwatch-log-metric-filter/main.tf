module label {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace  = var.namespace
  stage      = var.stage
  attributes = var.attributes
}

resource aws_cloudwatch_log_metric_filter this {
  name           = module.label.id
  pattern        = var.pattern
  log_group_name = var.log_group_name

  metric_transformation {
    name      = module.label.id
    namespace = "LogMetrics"
    value     = "1"
  }
}
