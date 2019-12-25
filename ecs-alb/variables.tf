variable namespace {
  type = string
}

variable stage {
  type = string
}

variable acm_arn {
  type = string
}

variable alb_security_ids {
  type = list
}

variable container_name {
  type = string
}

variable container_port {
  type = number
}

variable ecs_cluster_name {
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

variable ecs_iam_role {
  default = "ecsServiceRole"
}

variable ecs_task_definition {
  type = string
}

variable subnet_public_ids {
  type = list
}

variable vpc_id {
  type = string
}

variable min_capacity {
  default = 1
}

variable max_capacity {
  default = 1
}

variable desired_capacity {
  default = 1
}
