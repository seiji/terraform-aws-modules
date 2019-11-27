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

variable instance_types {
  type = list(string)
}

variable launch_template_id {
  type = string
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

variable target_group_arns {
  default = []
}

variable vpc_zone_identifier {
  type = list
}
