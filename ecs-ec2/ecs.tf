data aws_ecs_task_definition this {
  task_definition = var.ecs_task_definition
}

resource "random_id" "this" {
  byte_length = 1
}

resource aws_ecs_cluster this {
  name = module.label.id

  capacity_providers = [aws_ecs_capacity_provider.this.name]
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name
    weight            = 1
  }

  depends_on = [aws_ecs_capacity_provider.this]
}

resource aws_ecs_capacity_provider this {
  name = "${module.label.id}-${random_id.this.hex}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.autoscaling_group_arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource aws_ecs_service this {
  cluster                            = aws_ecs_cluster.this.id
  deployment_maximum_percent         = var.ecs_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.ecs_deployment_minimum_healthy_percent
  desired_count                      = var.ecs_desired_count
  name                               = module.label.id
  task_definition                    = "${data.aws_ecs_task_definition.this.family}:${data.aws_ecs_task_definition.this.revision}"

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    container_name   = var.lb_container_name
    container_port   = var.lb_container_port
    target_group_arn = var.lb_target_group_arn
  }

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = var.assign_public_ip
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  depends_on = [
    aws_ecs_cluster.this,
    data.aws_ecs_task_definition.this,
    aws_ecs_capacity_provider.this,
  ]

  lifecycle {
    ignore_changes = [
      desired_count,
    ]
  }
}
