resource aws_ecs_cluster this {
  name = var.ecs_cluster_name
}

data aws_ecs_task_definition this {
  task_definition = var.ecs_task_definition
}

resource aws_ecs_service this {
  name                               = module.label.id
  cluster                            = aws_ecs_cluster.this.id
  task_definition                    = "${data.aws_ecs_task_definition.this.family}:${data.aws_ecs_task_definition.this.revision}"
  desired_count                      = var.ecs_desired_count
  deployment_maximum_percent         = var.ecs_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.ecs_deployment_minimum_healthy_percent
  iam_role                           = var.ecs_iam_role

  depends_on = [
    aws_ecs_cluster.this,
    aws_alb_target_group.this,
  ]

  lifecycle {
    ignore_changes = [
      desired_count,
    ]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.this.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
}