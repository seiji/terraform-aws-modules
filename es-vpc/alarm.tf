resource aws_cloudwatch_metric_alarm cluster_status_is_red {
  count               = var.alarm_options.enabled ? 1 : 0
  alarm_name          = join("-", [module.label.id, "ElasticSearch-ClusterStatusIsRed"])
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ClusterStatus.red"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "At least one primary shard and its replicas are not allocated to a node"
  alarm_actions       = var.alarm_options.alarm_actions
  ok_actions          = var.alarm_options.ok_actions
  treat_missing_data  = "ignore"

  dimensions = {
    DomainName = aws_elasticsearch_domain.this.domain_name
  }
}
