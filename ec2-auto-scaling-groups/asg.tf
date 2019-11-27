resource aws_autoscaling_group this {
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

  timeouts {
    delete = "15m"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = module.label.tags_as_list_of_maps
}
