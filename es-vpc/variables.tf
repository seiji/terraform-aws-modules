variable namespace {
  type = string
}

variable stage {
  type = string
}

variable elasticsearch_version {
  type = string
}

variable subnet_ids {
  type = list
}

variable security_group_ids {
  default = []
}

variable volume_type {
  default = "gp2"
}

variable volume_size {
  default = 10
}

variable instance_type {
  default = "r5.large.elasticsearch"
}

variable instance_count {
  default = 1
}

