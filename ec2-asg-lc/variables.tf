variable namespace {
  type = string
}

variable stage {
  type = string
}

variable name {
  type = string
}

variable desired_capacity {
  default = 1
}

variable max_size {
  default = 1
}

variable min_size {
  default = 1
}

variable health_check_grace_period {
  default = 300
}

variable health_check_type {
  default = "EC2"
}

variable launch_configuration {
  type = string
}

variable target_group_arns {
  default = []
}

variable vpc_zone_identifier {
  type = list
}
