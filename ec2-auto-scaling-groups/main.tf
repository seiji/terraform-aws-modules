resource "aws_autoscaling_group" "this" {
  name                      = var.name
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired_capacity
  force_delete              = true
  launch_configuration      = var.launch_configuration
  vpc_zone_identifier       = var.vpc_zone_identifier
  target_group_arns         = var.target_group_arns

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    delete = "15m"
  }

  tags = [
    {
      key                 = "Name"
      value               = var.name
      propagate_at_launch = true
    },
    {
      key                 = "stage"
      value               = var.stage
      propagate_at_launch = true
    },
    {
      key                 = "namespace"
      value               = var.namespace
      propagate_at_launch = true
    }
  ]

  # tags = module.label.tags
}

