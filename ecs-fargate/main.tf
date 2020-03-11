module label {
  source    = "../label"
  namespace = var.namespace
  stage     = var.stage
}

data aws_ecs_task_definition this {
  task_definition = var.ecs_task_definition
}

resource aws_ecs_cluster this {
  name = module.label.id

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 1
    weight            = 1
  }

  tags = module.label.tags
}

resource aws_ecs_service this {
  cluster                            = aws_ecs_cluster.this.id
  deployment_maximum_percent         = var.ecs_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.ecs_deployment_minimum_healthy_percent
  desired_count                      = var.ecs_desired_count
  # launch_type                        = "FARGATE"
  name            = module.label.id
  task_definition = "${data.aws_ecs_task_definition.this.family}:${data.aws_ecs_task_definition.this.revision}"

  deployment_controller {
    type = "ECS"
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 1
    weight            = 1
  }

  dynamic load_balancer {
    for_each = var.load_balancers
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }
  network_configuration {
    subnets          = var.network_configuration.subnets
    security_groups  = var.network_configuration.security_groups
    assign_public_ip = var.network_configuration.assign_public_ip
  }

  depends_on = [
    aws_ecs_cluster.this,
    data.aws_ecs_task_definition.this,
  ]
  lifecycle {
    ignore_changes = [
      desired_count,
    ]
  }
}
