variable namespace {
  type = string
}

variable stage {
  type = string
}

variable elasticsearch_version {
  type = string
}

variable vpc_options {
  type = object({
    enabled            = bool
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = {
    enabled            = false
    subnet_ids         = []
    security_group_ids = []
  }
}

variable cluster_config {
  type = object({
    instance_type            = string
    instance_count           = number
    dedicated_master_enabled = bool
    availability_zone_count  = number
  })
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

variable cognito_options {
  type = object({
    enabled          = bool
    user_pool_id     = string
    identity_pool_id = string
    role_arn         = string
    auth_role_name   = string
  })
  default = {
    enabled          = false
    user_pool_id     = ""
    identity_pool_id = ""
    role_arn         = ""
    auth_role_name   = ""
  }
}

variable search_logs_enabled {
  default = false
}

variable index_logs_enabled {
  default = false
}

variable application_logs_enabled {
  default = false
}

variable allowed_ips {
  type    = list(string)
  default = []
}
