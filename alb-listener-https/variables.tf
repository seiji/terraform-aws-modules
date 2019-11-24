variable namespace {
  type = string
}

variable stage {
  type = string
}

variable name {
  type = string
}

variable vpc_id {
  type = string
}

variable security_groups {
  default = []
}

variable subnets {
  type = list
}

variable certificate_arn {
  type = string
}

variable target_group_arn {
  type = string
}
