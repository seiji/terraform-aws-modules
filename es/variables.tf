variable "namespace" {
  type = string
}

variable "stage" {
  type = string
}

variable "elasticsearch_version" {
  type = string
}

variable "vpc_options" {
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

variable "cluster_config" {
  type = object({
    instance_type            = string
    instance_count           = number
    dedicated_master_enabled = bool
    availability_zone_count  = number
  })
}

variable "ebs_options" {
  type = object({
    ebs_enabled = bool
    volume_type = string
    volume_size = number
  })
  default = {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = 10
  }
}

variable "encrypt_at_rest" {
  default = false
}

variable "kms_key_id" {
  default = null
}

variable "node_to_node_encryption" {
  default = false
}

variable "automated_snapshot_start_hour" {
  default = 23
}

variable "cognito_options" {
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

variable "search_logs_enabled" {
  default = false
}

variable "index_logs_enabled" {
  default = false
}

variable "application_logs_enabled" {
  default = false
}

variable "allowed_ips" {
  type    = list(string)
  default = []
}

variable "alarm_options" {
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
