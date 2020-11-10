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
  default = 0
}

variable desired_capacity {
  default = 0
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

variable on_demand_base_capacity {
  default = 0
}

variable on_demand_percentage_above_base_capacity {
  default = 0
}

variable protect_from_scale_in {
  default = false
}

variable alarm_options {
  type = object({
    enabled       = bool
    alarm_actions = list(string)
    ok_actions    = list(string)
  })
  default = {
    enabled       = false
    alarm_actions = []
    ok_actions    = []
  }
}
