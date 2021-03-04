module "label_app" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = concat(var.attributes, ["app"])
  name       = var.name
  add_tags   = var.add_tags
}

module "label_deployment_group" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = concat(var.attributes, ["deployment-group"])
  name       = var.name
  add_tags   = var.add_tags
}

resource "aws_codedeploy_app" "this" {
  compute_platform = var.compute_platform
  name             = module.label_app.id
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_config_name = var.deployment_config_name
  deployment_group_name  = module.label_deployment_group.id
  service_role_arn       = var.service_role_arn

  auto_rollback_configuration {
    enabled = var.auto_rollback_configuration.enabled
    events  = var.auto_rollback_configuration.events
  }

  dynamic "blue_green_deployment_config" {
    for_each = var.blue_green_deployment_config != null ? [var.blue_green_deployment_config] : []
    content {
      deployment_ready_option {
        action_on_timeout    = blue_green_deployment_config.value.deployment_ready_option.action_on_timeout
        wait_time_in_minutes = blue_green_deployment_config.value.deployment_ready_option.wait_time_in_minutes
      }
      terminate_blue_instances_on_deployment_success {
        action                           = blue_green_deployment_config.value.terminate_blue_instances_on_deployment_success.action
        termination_wait_time_in_minutes = blue_green_deployment_config.value.terminate_blue_instances_on_deployment_success.termination_wait_time_in_minutes
      }
    }
  }

  dynamic "deployment_style" {
    for_each = var.deployment_style != null ? [var.deployment_style] : []
    content {
      deployment_option = deployment_style.value.deployment_option
      deployment_type   = deployment_style.value.deployment_type
    }
  }

  ecs_service {
    cluster_name = var.ecs_service.cluster_name
    service_name = var.ecs_service.service_name
  }

  dynamic "load_balancer_info" {
    for_each = [var.load_balancer_info]
    content {
      dynamic "target_group_info" {
        for_each = load_balancer_info.value.target_group_info != null ? [load_balancer_info.value.target_group_info] : []
        content {
          name = target_group_info.value.name
        }
      }
      dynamic "target_group_pair_info" {
        for_each = load_balancer_info.value.target_group_pair_info != null ? [load_balancer_info.value.target_group_pair_info] : []
        content {
          prod_traffic_route {
            listener_arns = target_group_pair_info.value.prod_listener_arns
          }
          dynamic "target_group" {
            for_each = target_group_pair_info.value.target_group_names
            content {
              name = target_group.value
            }
          }
          dynamic "test_traffic_route" {
            for_each = target_group_pair_info.value.test_listener_arns
            content {
              listener_arns = target_group_pair_info.value.test_listener_arns
            }
          }
        }
      }
    }
  }
  depends_on = [aws_codedeploy_app.this]
}
