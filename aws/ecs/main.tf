module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

data "aws_ecs_task_definition" "this" {
  task_definition = var.task_definition
}

resource "aws_ecs_cluster" "this" {
  name               = module.label.id
  capacity_providers = var.cluster.capacity_providers
  default_capacity_provider_strategy {
    capacity_provider = var.cluster.default_capacity_provider
    base              = 1
    weight            = 1
  }
  tags = module.label.tags
}

resource "aws_ecs_service" "this" {
  name = module.label.id
  capacity_provider_strategy {
    capacity_provider = var.capacity_provider
    base              = 1
    weight            = 1
  }
  cluster = aws_ecs_cluster.this.id
  deployment_controller {
    type = var.deployment_controller_type
  }
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  desired_count                      = var.desired_count
  enable_ecs_managed_tags            = true
  # launch_type                        = "FARGATE"
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  platform_version                  = var.platform_version
  dynamic "load_balancer" {
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
  task_definition = "${data.aws_ecs_task_definition.this.family}:${data.aws_ecs_task_definition.this.revision}"
  tags            = module.label.tags
  depends_on = [
    aws_ecs_cluster.this,
    data.aws_ecs_task_definition.this,
  ]
  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
    ]
  }
}
