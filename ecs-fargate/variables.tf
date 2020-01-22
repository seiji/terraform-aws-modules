variable namespace {
  type = string
}

variable stage {
  type = string
}

variable lb_container_name {
  type = string
}

variable lb_container_port {
  type = number
}

variable lb_target_group_arn {
  type = string
}

variable ecs_desired_count {
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

variable subnets {
  type = list
}

variable security_groups {
  type = list
}

variable assign_public_ip {
  default = false
}
