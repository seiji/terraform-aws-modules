resource "aws_appautoscaling_target" "this" {
  count              = var.appautoscaling.target != null ? 1 : 0
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  # role_arn           = data.aws_iam_role.aas_ecs.arn
  min_capacity = var.appautoscaling.target.min_capacity
  max_capacity = var.appautoscaling.target.max_capacity

  lifecycle {
    ignore_changes = [min_capacity, max_capacity]
  }
  depends_on = [
    aws_ecs_cluster.this,
    aws_ecs_service.this,
  ]
}

resource "aws_appautoscaling_scheduled_action" "scale_out" {
  count              = var.appautoscaling.scheduled_scale_out != null ? 1 : 0
  name               = join("-", [module.label.id, "scheduled_scale_out"])
  resource_id        = aws_appautoscaling_target.this[0].resource_id
  scalable_dimension = aws_appautoscaling_target.this[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.this[0].service_namespace
  schedule           = var.appautoscaling.scheduled_scale_out.schedule
  timezone           = "Asia/Tokyo"

  scalable_target_action {
    min_capacity = var.appautoscaling.scheduled_scale_out.min_capacity
    max_capacity = var.appautoscaling.scheduled_scale_out.max_capacity
  }

  depends_on = [aws_appautoscaling_target.this[0]]
}

resource "aws_appautoscaling_scheduled_action" "scale_in" {
  count              = var.appautoscaling.scheduled_scale_in != null ? 1 : 0
  name               = join("-", [module.label.id, "scheduled_scale_in"])
  resource_id        = aws_appautoscaling_target.this[0].resource_id
  scalable_dimension = aws_appautoscaling_target.this[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.this[0].service_namespace
  schedule           = var.appautoscaling.scheduled_scale_in.schedule
  timezone           = "Asia/Tokyo"

  scalable_target_action {
    min_capacity = var.appautoscaling.scheduled_scale_in.min_capacity
    max_capacity = var.appautoscaling.scheduled_scale_in.max_capacity
  }

  depends_on = [aws_appautoscaling_target.this[0]]
}
