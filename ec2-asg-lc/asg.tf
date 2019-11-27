resource aws_autoscaling_group this {
  name                      = var.name
  desired_capacity          = var.desired_capacity
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
