module "label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  stage     = var.stage

  additional_tag_map = {
    propagate_at_launch = "true"
  }
}

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
  enabled_metrics           = local.enabled_metrics
  force_delete              = true
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
        version            = "$Latest"
      }

      dynamic override {
        for_each = var.instance_types
        content {
          instance_type = override.value
        }
      }
    }
    instances_distribution {
      on_demand_allocation_strategy            = "prioritized"
      on_demand_base_capacity                  = var.on_demand_base_capacity
      on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
      spot_allocation_strategy                 = "lowest-price"
      spot_instance_pools                      = 2
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
