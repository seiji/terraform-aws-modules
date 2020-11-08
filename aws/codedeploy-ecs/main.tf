module label {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

resource aws_codedeploy_app this {
  compute_platform = "ECS"
  name             = module.label.id
}

resource aws_codedeploy_deployment_group this {
  app_name               = aws_codedeploy_app.this.name
  deployment_config_name = var.deployment_config_name
  deployment_group_name  = module.label.id
  service_role_arn       = var.service_role_arn

  # auto_rollback_configuration {
  #   enabled = false
  #   events  = ["DEPLOYMENT_FAILURE"]
  # }
  #
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_service.cluster_name
    service_name = var.ecs_service.service_name
  }

  dynamic load_balancer_info {
    for_each = [var.load_balancer_info]
    content {
      dynamic target_group_info {
        for_each = load_balancer_info.value.target_group_info != null ? [load_balancer_info.value.target_group_info] : []
        content {
          name = target_group_info.value.name
        }
      }
    }
    # target_group_pair_info {
    #   prod_traffic_route {
    #     listener_arns = [aws_lb_listener.example.arn]
    #   }
    #
    #   target_group {
    #     name = aws_lb_target_group.blue.name
    #   }
    #
    #   target_group {
    #     name = aws_lb_target_group.green.name
    #   }
    # }
  }
  depends_on = [aws_codedeploy_app.this]
}
