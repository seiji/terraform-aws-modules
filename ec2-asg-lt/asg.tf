locals {
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]
}

resource aws_autoscaling_group this {
  name                      = var.name
  desired_capacity          = var.desired_capacity
  force_delete              = true
  enabled_metrics           = local.enabled_metrics
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  max_size                  = var.max_size
  min_size                  = var.min_size
  target_group_arns         = var.target_group_arns
  termination_policies      = ["OldestInstance"]
  vpc_zone_identifier       = var.vpc_zone_identifier

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = var.launch_template_id
        # version            = var.launch_template_version
        version = "$Latest"
      }

      dynamic override {
        for_each = var.instance_types
        content {
          instance_type = override.value
        }
      }
    }

    instances_distribution {
      on_demand_base_capacity                  = 1
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "lowest-price"
      spot_instance_pools                      = "2"
    }
  }
  protect_from_scale_in = true
  timeouts {
    delete = "15m"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }

  tags = module.label.tags_as_list_of_maps
}

# resource aws_autoscaling_policy scale_out {
#   name                   = "${var.name}-scale-out"
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300
#   scaling_adjustment     = 1
#   autoscaling_group_name = aws_autoscaling_group.this.name
# }
#
# resource aws_autoscaling_policy scale_in {
#   name                   = "${var.name}-scale-in"
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300
#   scaling_adjustment     = -1
#   autoscaling_group_name = aws_autoscaling_group.this.name
# }
