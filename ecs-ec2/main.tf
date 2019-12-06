module label {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  stage     = var.stage
}

resource "aws_ecs_cluster" "this" {
  name = module.label.id
}

data "aws_ecs_task_definition" "this" {
  task_definition = module.label.id
}

resource "aws_ecs_service" "this" {
  name                               = module.label.id
  cluster                            = aws_ecs_cluster.this.id
  task_definition                    = "${data.aws_ecs_task_definition.this.family}:${data.aws_ecs_task_definition.this.revision}"
  desired_count                      = var.ecs_desired_count
  deployment_maximum_percent         = var.ecs_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.ecs_deployment_minimum_healthy_percent
  iam_role                           = var.ecs_iam_role

  depends_on = [aws_alb_listener.this]
  lifecycle {
    ignore_changes = [
      "desired_count",
    ]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.this.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
}
