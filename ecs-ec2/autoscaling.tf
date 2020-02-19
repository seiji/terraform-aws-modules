data "aws_iam_role" "aas_ecs" {
  name = "AWSServiceRoleForApplicationAutoScaling_ECSService"
}

resource "aws_appautoscaling_target" "this" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = data.aws_iam_role.aas_ecs.arn
  min_capacity       = var.ecs_min_capacity
  max_capacity       = var.ecs_max_capacity

  depends_on = [
    aws_ecs_cluster.this,
    aws_ecs_service.this,
    data.aws_iam_role.aas_ecs,
  ]
}

# resource "aws_appautoscaling_policy" "ecs_service_cpu_autoscaling_policy" {
#   count              = "${var.ecs_service_cpu_autoscale_policy_enabled? 1 : 0}"
#   name               = "scale-up-from-cpu-utilization"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = "service/${var.ecs_cluster}/${var.project_name}-${var.env}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
#
#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }
#
#     target_value            = "${var.ecs_cpu_autoscale_target_value}"
#     scale_in_cooldown       = "${var.ecs_cpu_autoscale_scale_in_cooldown}"
#     scale_out_cooldown      = "${var.ecs_cpu_autoscale_scale_out_cooldown}"
#   }
# }
#
# resource "aws_appautoscaling_policy" "ecs_service_memory_autoscaling_policy" {
#   count              = "${var.ecs_service_memory_autoscale_policy_enabled? 1 : 0}"
#   name               = "scale-up-from-memory-utilization"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = "service/${var.ecs_cluster}/${var.project_name}-${var.env}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
#
#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageMemoryUtilization"
#     }
#
#     target_value            = "${var.ecs_memory_autoscale_target_value}"
#     scale_in_cooldown       = "${var.ecs_memory_autoscale_scale_in_cooldown}"
#     scale_out_cooldown      = "${var.ecs_memory_autoscale_scale_out_cooldown}"
#   }
# }
#
# resource "aws_appautoscaling_policy" "ecs_service_request_count_autoscaling_policy" {
#   count              = "${var.ecs_service_request_count_autoscale_policy_enabled? 1 : 0}"
#   name               = "scale-up-from-request-count-per-target"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = "service/${var.ecs_cluster}/${var.project_name}-${var.env}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
#
#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ALBRequestCountPerTarget"
#       resource_label = "${var.target_group_resource_label}"
#     }
#
#     target_value            = "${var.ecs_request_count_autoscale_target_value}"
#     scale_in_cooldown       = "${var.ecs_request_count_autoscale_scale_in_cooldown}"
#     scale_out_cooldown      = "${var.ecs_request_count_autoscale_scale_out_cooldown}"
#   }
# }

#
# resource "aws_appautoscaling_policy" "scale_out" {
#   name               = "${local.name}-scale-out"
#   resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
#   depends_on         = ["aws_appautoscaling_target.this"]
#   scalable_dimension = "${aws_appautoscaling_target.this.scalable_dimension}"
#   service_namespace  = "${aws_appautoscaling_target.this.service_namespace}"
#
#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 300
#     metric_aggregation_type = "Maximum"
#
#     step_adjustment {
#       metric_interval_lower_bound = 0
#       scaling_adjustment          = 1
#     }
#   }
# }
#
# resource "aws_appautoscaling_policy" "scale_in" {
#   name               = "${local.name}-scale-in"
#   resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
#   depends_on         = ["aws_appautoscaling_target.this"]
#   scalable_dimension = "${aws_appautoscaling_target.this.scalable_dimension}"
#   service_namespace  = "${aws_appautoscaling_target.this.service_namespace}"
#
#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 300
#     metric_aggregation_type = "Average"
#
#     step_adjustment {
#       metric_interval_upper_bound = 0
#       scaling_adjustment          = -1
#     }
#   }
# }
