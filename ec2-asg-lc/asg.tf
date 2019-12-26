resource aws_autoscaling_group this {
  name = var.name
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
  force_delete              = true
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  launch_configuration      = var.launch_configuration
  max_size                  = var.max_size
  min_size                  = var.min_size
  target_group_arns         = var.target_group_arns
  vpc_zone_identifier       = var.vpc_zone_identifier

  timeouts {
    delete = "15m"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = module.label.tags_as_list_of_maps
}

resource aws_autoscaling_policy this {
  name                      = "${var.name}-scaling"
  autoscaling_group_name    = aws_autoscaling_group.this.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "180"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.policy_target_tracking.predefined_metric_type
    }
    target_value     = var.policy_target_tracking.target_value
    disable_scale_in = var.policy_target_tracking.disable_scale_in
  }

  # target_tracking_configuration {
  #   customized_metric_specification {
  #     metric_dimension {
  #       name  = "ClusterName"
  #       value = var.cluster_name
  #     }
  #
  #     metric_name = "CPUReservation"
  #     namespace   = "AWS/ECS"
  #     statistic   = "Average"
  #   }
  #
  #   target_value = var.policy_target_tracking.target_value
  # }

  depends_on = [aws_autoscaling_group.this]
}
