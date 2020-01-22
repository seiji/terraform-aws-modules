module label {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  stage     = var.stage
}

data aws_ecs_task_definition this {
  task_definition = var.ecs_task_definition
}

resource aws_ecs_cluster this {
  name = module.label.id

  capacity_providers  = ["FARGATE", "FARGATE_SPOT"]
  # default_capacity_provider_strategy {
  #   base              = 1
  #   capacity_provider = "FARGATE"
  #   weight            = 1
  # }
  default_capacity_provider_strategy {
    base              = 1
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource aws_ecs_service this {
  cluster                            = aws_ecs_cluster.this.id
  deployment_maximum_percent         = var.ecs_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.ecs_deployment_minimum_healthy_percent
  desired_count                      = var.ecs_desired_count
  launch_type                        = "FARGATE"
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
