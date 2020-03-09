variable namespace {
  type = string
}

variable stage {
  type = string
}

variable load_balancers {
  type = list(object({
    container_name   = string
    container_port   = number
    target_group_arn = string
  }))
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

variable aas_min_capacity {
  default = 1
}

variable aas_max_capacity {
  default = 1
}

variable aas_policy_cpu {
  type = object({
    enabled        = bool
    threshold_high = number
    threshold_low  = number
  })
  default = {
    enabled        = false
    threshold_high = 60
    threshold_low  = 30
  }
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
