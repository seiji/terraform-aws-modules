variable service {
  type = string
}

variable env {
  type = string
}

variable attributes {
  type    = list(string)
  default = []
}

variable name {
  type    = string
  default = ""
}

variable add_tags {
  type    = map(string)
  default = {}
}

variable deployment_controller_type {
  type    = string
  default = "ECS"
}

variable deployment_maximum_percent {
  default = 200
}

variable deployment_minimum_healthy_percent {
  default = 100
}

variable desired_count {
  default = 1
}

variable load_balancers {
  type = list(object({
    container_name   = string
    container_port   = number
    target_group_arn = string
  }))
  default = []
}

variable network_configuration {
  type = object({
    subnets          = list(string)
    security_groups  = list(string)
    assign_public_ip = bool
  })
}

variable task_definition {
  type = string
}
