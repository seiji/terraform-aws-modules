resource aws_cloudwatch_metric_alarm group_in_service_instances {
  count               = var.alarm_options.enabled ? 1 : 0
  alarm_name          = join("-", [module.label.id, "AWS/AutoScaling/GroupInServiceInstances"])
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "GroupInServiceInstances"
  namespace           = "AWS/AutoScaling"
  period              = 60
  statistic           = "Minimum"
  threshold           = 1
  alarm_actions       = var.alarm_options.alarm_actions
  ok_actions          = var.alarm_options.ok_actions
  treat_missing_data  = "ignore"

  dimensions = {
    AutoScalingGroupName = module.label.id
  }

  tags = module.label.tags
}
