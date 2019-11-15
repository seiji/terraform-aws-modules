locals {
  thresholds = {
    CPUUtilization = 80
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  count               = length(var.db_instance_ids)
  alarm_name          = "${var.db_instance_ids[count.index]}-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = local.thresholds["CPUUtilization"]
  alarm_actions       = [var.sns_topic_arn]
  ok_actions          = [var.sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_ids[count.index]
  }
}
