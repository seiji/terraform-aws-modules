variable namespace {
  type = string
}

variable stage {
  type = string
}

variable autoscaling_group_arn {
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

variable min_capacity {
  default = 1
}

variable max_capacity {
  default = 1
}

variable desired_capacity {
  default = 0
}

variable subnets {
  type = list(string)
}

variable security_groups {
  type = list(string)
}

variable assign_public_ip {
  default = false
}

variable "service_discovery_namespace_id" {
  type = string
}
