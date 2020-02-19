variable namespace {
  type = string
}

variable stage {
  type = string
}

variable autoscaling_group_arn {
  type = string
}

variable load_balancer {
  type = object({
    container_name   = string
    container_port   = number
    target_group_arn = string
  })
}

variable network_configuration {
  type = object({
    subnets          = list(string)
    security_groups  = list(string)
    assign_public_ip = bool
  })
}

variable ecs_desired_count {
  default = 1
}

variable ecs_min_capacity {
  default = 1
}

variable ecs_max_capacity {
  default = 1
}

variable ecs_deployment_maximum_percent {
  default = 200
}

variable ecs_deployment_minimum_healthy_percent {
  default = 100
}

variable ecs_task_definition {
  type = string
}

variable "service_discovery_namespace_id" {
  type = string
}
