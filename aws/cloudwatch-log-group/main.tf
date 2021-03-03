module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  name       = var.name
  attributes = var.attributes
  delimiter  = "/"
  prefix     = "/"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = module.label.id
  retention_in_days = var.retention_in_days
  tags              = module.label.tags
}

resource "aws_cloudwatch_log_metric_filter" "this" {
  for_each       = var.metric_filters
  name           = each.key
  pattern        = each.value.pattern
  log_group_name = aws_cloudwatch_log_group.this.name
  metric_transformation {
    name      = each.key
    namespace = each.value.metric_transformation.namespace
    value     = each.value.metric_transformation.value
  }
  depends_on = [
    aws_cloudwatch_log_group.this,
  ]
}

resource "aws_cloudwatch_log_subscription_filter" "this" {
  count           = var.subscription_filter == null ? 0 : 1
  name            = var.subscription_filter.name
  destination_arn = var.subscription_filter.destination_arn
  distribution    = var.subscription_filter.distribution
  filter_pattern  = var.subscription_filter.filter_pattern
  log_group_name  = aws_cloudwatch_log_group.this.name
  role_arn        = var.subscription_filter.role_arn
  depends_on      = [aws_cloudwatch_log_group.this]
}

