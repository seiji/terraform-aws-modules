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
  name = module.label.id
  tags = module.label.tags
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name = "/aws/ecsexec/logging"
      }
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  count              = var.cluster != null ? 1 : 0
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = var.cluster != null ? var.cluster.capacity_providers : null
  dynamic "default_capacity_provider_strategy" {
    for_each = var.cluster != null && var.cluster.default_capacity_provider != null ? [var.cluster.default_capacity_provider] : []
    content {
      capacity_provider = default_capacity_provider_strategy.value
      base              = 1
      weight            = 1
    }
  }
  depends_on = [aws_ecs_cluster.this]
}

resource "aws_ecs_service" "this" {
  name = module.label.id
  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider != null ? [var.capacity_provider] : []
    content {
      capacity_provider = capacity_provider_strategy.value
      base              = 1
      weight            = 1
    }
  }
  cluster = aws_ecs_cluster.this.id
  deployment_controller {
    type = var.deployment_controller_type
  }
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  desired_count                      = var.desired_count
  enable_ecs_managed_tags            = true
  enable_execute_command             = var.enable_execute_command
  # launch_type                        = "FARGATE"
  health_check_grace_period_seconds = length(var.load_balancers) != 0 ? var.health_check_grace_period_seconds : null
  platform_version                  = var.platform_version
  dynamic "deployment_circuit_breaker" {
    for_each = var.deployment_circuit_breaker_rollback ? [true] : []
    content {
      enable   = true
      rollback = true
    }
  }
  dynamic "load_balancer" {
    for_each = var.load_balancers
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }
  dynamic "network_configuration" {
    for_each = var.network_configuration != null ? [var.network_configuration] : []
    content {
      subnets          = network_configuration.value.subnets
      security_groups  = network_configuration.value.security_groups
      assign_public_ip = network_configuration.value.assign_public_ip
    }
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
