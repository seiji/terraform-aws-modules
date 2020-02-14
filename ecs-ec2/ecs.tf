resource aws_ecs_cluster this {
  name = module.label.id
}

data aws_ecs_task_definition this {
  task_definition = var.ecs_task_definition
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
