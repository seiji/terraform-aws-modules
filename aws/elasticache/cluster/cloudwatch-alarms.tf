locals {
  cpu_percent_threshold      = 90
  swap_usage_threshold       = 50000000
  curr_connections_threshold = 40000
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  for_each            = var.alarm_options.enabled && (var.alarm_options.node_vcpu < 4) ? aws_elasticache_replication_group.this.member_clusters : toset([])
  alarm_name          = join("-", [module.label.id, "elasticache-CPUUtilization", each.value])
  alarm_description   = "CPUUtilization is ${local.cpu_percent_threshold}%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Average"
  threshold           = ceil(local.cpu_percent_threshold / var.alarm_options.node_vcpu)
  alarm_actions       = var.alarm_options.alarm_actions
  ok_actions          = var.alarm_options.ok_actions
  treat_missing_data  = "ignore"
  dimensions = {
    CacheClusterId = each.value
  }

  depends_on = [
    aws_elasticache_replication_group.this,
  ]
  tags = module.label.tags
}

resource "aws_cloudwatch_metric_alarm" "engine_cpu_utilization" {
  for_each            = var.alarm_options.enabled && (var.alarm_options.node_vcpu >= 4) ? aws_elasticache_replication_group.this.member_clusters : toset([])
  alarm_name          = join("-", [module.label.id, "elasticache-EngineCPUUtilization", each.value])
  alarm_description   = "EngineCPUUtilization is ${local.cpu_percent_threshold}%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "EngineCPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Average"
  threshold           = local.cpu_percent_threshold
  alarm_actions       = var.alarm_options.alarm_actions
  ok_actions          = var.alarm_options.ok_actions
  treat_missing_data  = "ignore"
  dimensions = {
    CacheClusterId = each.value
  }

  depends_on = [
    aws_elasticache_replication_group.this,
  ]
  tags = module.label.tags
}

resource "aws_cloudwatch_metric_alarm" "swap_usage" {
  for_each            = var.alarm_options.enabled ? aws_elasticache_replication_group.this.member_clusters : toset([])
  alarm_name          = join("-", [module.label.id, "elasticache-SwapUsage", each.value])
  alarm_description   = "SwapUsage is ${local.swap_usage_threshold}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "SwapUsage"
  namespace           = "AWS/ElastiCache"
  period              = 60
  statistic           = "Maximum"
  threshold           = local.swap_usage_threshold
  alarm_actions       = var.alarm_options.alarm_actions
  ok_actions          = var.alarm_options.ok_actions
  treat_missing_data  = "ignore"
  dimensions = {
    CacheClusterId = each.value
  }

  depends_on = [
    aws_elasticache_replication_group.this,
  ]
  tags = module.label.tags
}

resource "aws_cloudwatch_metric_alarm" "evictions" {
  for_each            = var.alarm_options.enabled ? aws_elasticache_replication_group.this.member_clusters : toset([])
  alarm_name          = join("-", [module.label.id, "elasticache-Evictions", each.value])
  alarm_description   = "Evictions is greater than 0."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Evictions"
  namespace           = "AWS/ElastiCache"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  alarm_actions       = var.alarm_options.alarm_actions
  ok_actions          = var.alarm_options.ok_actions
  treat_missing_data  = "ignore"
  dimensions = {
    CacheClusterId = each.value
  }

  tags = module.label.tags
}

resource "aws_cloudwatch_metric_alarm" "curr_connections" {
  for_each            = var.alarm_options.enabled ? aws_elasticache_replication_group.this.member_clusters : toset([])
  alarm_name          = join("-", [module.label.id, "elasticache-CurrConnections", each.value])
  alarm_description   = "CurrConnections is greater than ${local.curr_connections_threshold}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CurrConnections"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Average"
  threshold           = local.curr_connections_threshold
  alarm_actions       = var.alarm_options.alarm_actions
  ok_actions          = var.alarm_options.ok_actions
  treat_missing_data  = "ignore"
  dimensions = {
    CacheClusterId = each.value
  }

  depends_on = [
    aws_elasticache_replication_group.this,
  ]
  tags = module.label.tags
}
