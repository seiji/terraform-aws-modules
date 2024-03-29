data "aws_ecs_task_definition" "this" {
  task_definition = var.ecs_task_definition
}

resource "random_id" "this" {
  byte_length = 1
}

resource "aws_ecs_cluster" "this" {
  name               = module.label.id
  capacity_providers = [aws_ecs_capacity_provider.this.name]
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name
    base              = 1
    weight            = 1
  }

  depends_on = [aws_ecs_capacity_provider.this]
  tags       = module.label.tags
}

resource "aws_ecs_capacity_provider" "this" {
  name = join("-", [module.label.id, random_id.this.hex])
  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.asg_arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
  tags = module.label.tags
}

resource "aws_ecs_service" "this" {
  cluster                            = aws_ecs_cluster.this.id
  deployment_maximum_percent         = var.ecs_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.ecs_deployment_minimum_healthy_percent
  desired_count                      = var.ecs_desired_count
  name                               = module.label.id
  task_definition                    = "${data.aws_ecs_task_definition.this.family}:${data.aws_ecs_task_definition.this.revision}"
  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name
    base              = 1
    weight            = 1
  }
  deployment_controller {
    type = "ECS"
  }

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
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
  ordered_placement_strategy {
    field = "memory"
    type  = "binpack"
  }
  dynamic "service_registries" {
    for_each = var.service_discovery.enabled ? [var.service_discovery] : []
    content {
      registry_arn = aws_service_discovery_service.this[0].arn
    }
  }

  depends_on = [
    aws_ecs_capacity_provider.this,
    aws_ecs_cluster.this,
    aws_service_discovery_service.this,
    data.aws_ecs_task_definition.this,
  ]
  lifecycle {
    ignore_changes = [
      desired_count,
    ]
  }
}

resource "aws_service_discovery_service" "this" {
  count = var.service_discovery.enabled ? 1 : 0
  name  = module.label.id

  dns_config {
    namespace_id = var.service_discovery.namespace_id

    dns_records {
      ttl  = 60
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
