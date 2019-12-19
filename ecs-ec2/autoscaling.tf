# resource "aws_appautoscaling_target" "this" {
#   service_namespace  = "ecs"
#   resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   # role_arn           = data.aws_iam_role.ecs_autoscale_service_linked_role.arn
#   min_capacity = var.min_capacity
#   max_capacity = var.max_capacity
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
