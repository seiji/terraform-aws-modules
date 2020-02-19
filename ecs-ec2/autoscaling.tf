data "aws_iam_role" "aas_ecs" {
  name = "AWSServiceRoleForApplicationAutoScaling_ECSService"
}

locals {
  aas_resource_id = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
}

resource "aws_appautoscaling_target" "this" {
  service_namespace  = "ecs"
  resource_id        = local.aas_resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = data.aws_iam_role.aas_ecs.arn
  min_capacity       = var.aas_min_capacity
  max_capacity       = var.aas_max_capacity

  depends_on = [
    aws_ecs_cluster.this,
    aws_ecs_service.this,
    data.aws_iam_role.aas_ecs,
  ]
}

resource "aws_appautoscaling_policy" "scalein" {
  name               = join("-", [module.label.id, "scaleIn"])
  resource_id        = local.aas_resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [
    aws_ecs_cluster.this,
    aws_ecs_service.this,
    aws_appautoscaling_target.this,
  ]
}

resource "aws_appautoscaling_policy" "scaleout" {
  name               = join("-", [module.label.id, "scaleout"])
  resource_id        = local.aas_resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [
    aws_ecs_cluster.this,
    aws_ecs_service.this,
    aws_appautoscaling_target.this,
  ]
}

resource "aws_cloudwatch_metric_alarm" "scalein" {
  alarm_name          = join("-", ["CustomTracking", module.label.id, "AlarmLow"])
  alarm_actions       = [aws_appautoscaling_policy.scalein.arn]
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  threshold           = "1"

  metric_query {
    id          = "mq"
    expression  = "asg>1 AND cpu<${var.aas_policy_cpu.threshold_low}"
    label       = "AutoScaling GroupTotalInstances and CPU Utilization for ScaleIn"
    return_data = "true"
  }

  metric_query {
    id = "asg"
    metric {
      metric_name = "GroupTotalInstances"
      namespace   = "AWS/AutoScaling"
      period      = "60"
      stat        = "Average"
      unit        = "Count"
      dimensions = {
        AutoScalingGroupName = var.asg_name
      }
    }
  }

  metric_query {
    id = "cpu"
    metric {
      metric_name = "CPUUtilization"
      namespace   = "AWS/ECS"
      period      = 60
      stat        = "Average"
      unit        = "Percent"
      dimensions = {
        ClusterName = aws_ecs_cluster.this.name
        ServiceName = aws_ecs_service.this.name
      }
    }
  }
  depends_on = [
    aws_ecs_cluster.this,
    aws_ecs_service.this,
    aws_appautoscaling_target.this,
    aws_appautoscaling_policy.scalein,
  ]
}

resource "aws_cloudwatch_metric_alarm" "scaleout" {
  alarm_actions       = [aws_appautoscaling_policy.scaleout.arn]
  alarm_name          = join("-", ["CustomTracking", module.label.id, "AlarmHigh"])
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = var.aas_policy_cpu.threshold_high
  unit                = "Percent"

  dimensions = {
    ClusterName = aws_ecs_cluster.this.name
    ServiceName = aws_ecs_service.this.name
  }

  depends_on = [
    aws_ecs_cluster.this,
    aws_ecs_service.this,
    aws_appautoscaling_target.this,
    aws_appautoscaling_policy.scalein,
  ]
}
# resource "aws_appautoscaling_policy" "tgt_cpu" {
#   count              = var.aas_policy_tgt_cpu.enabled ? 1 : 0
#   name               = join("-", [module.label.id, "tgt", "cpu"])
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = local.aas_resource_id
#   scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.this.service_namespace
#
#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }
#     disable_scale_in   = false
#     target_value       = var.aas_policy_tgt_cpu.target_value
#     scale_in_cooldown  = var.aas_policy_tgt_cpu.scale_in_cooldown
#     scale_out_cooldown = var.aas_policy_tgt_cpu.scale_out_cooldown
#   }
#   depends_on = [
#     aws_ecs_cluster.this,
#     aws_ecs_service.this,
#     aws_appautoscaling_target.this,
#   ]
# }

#
