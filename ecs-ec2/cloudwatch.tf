# resource "aws_cloudwatch_metric_alarm" "service_memory_high" {
#   alarm_name          = "${local.name}-service-memory-high"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = 3
#   metric_name         = "MemoryUtilization"
#   namespace           = "AWS/ECS"
#   period              = 60
#   statistic           = "Maximum"
#   threshold           = 80
#   alarm_actions       = [aws_appautoscaling_policy.scale_out.arn]
#
#   dimensions = {
#     ClusterName = "${local.name}"
#     ServiceName = "${local.name}"
#   }
# }
#
# resource "aws_cloudwatch_metric_alarm" "service_memory_low" {
#   alarm_name          = "${local.name}-service-memory-low"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = 3
#   metric_name         = "MemoryUtilization"
#   namespace           = "AWS/ECS"
#   period              = 60
#   statistic           = "Maximum"
#   threshold           = 20
#   alarm_actions       = [aws_appautoscaling_policy.scale_in.arn]
#
#   dimensions = {
#     ClusterName = local.name
#     ServiceName = local.name
#   }
# }
