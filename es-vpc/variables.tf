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

variable instance_type {
  default = "r5.large.elasticsearch"
}

variable instance_count {
  type = number
}

variable volume_type {
  default = "gp2"
}

variable volume_size {
  default = 10
}

variable encrypt_at_rest {
  default = false
}

variable kms_key_id {
  default = null
}

variable node_to_node_encryption {
  default = false
}

variable automated_snapshot_start_hour {
  default = 23
}

