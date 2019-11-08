variable namespace {}
variable stage {}

variable vpc_id {}
variable subnet_private_id_list {
  type = list
}

variable subnet_public_id_list {
  type = list
}

variable alb_security_id_list {
  type = list
}

variable ec2_security_id_list {
  type = list
}
variable key_name {}
variable image_id {}
variable instance_type {}
variable ec2_iam_role {}

variable acm_arn {}

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

variable container_name {}
variable container_port {
  type = number
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
