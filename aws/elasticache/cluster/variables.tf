variable "service" {
  type = string
}

variable "env" {
  type = string
}

variable "attributes" {
  type    = list(string)
  default = []
}

variable "name" {
  type    = string
  default = ""
}

variable "add_tags" {
  type    = map(string)
  default = {}
}

variable "description" {
  type    = string
  default = "Managed by Terraform"
}

variable "automatic_failover_enabled" {
  type    = bool
  default = false
}

variable "number_cache_clusters" {
  type = number
}

variable "node_type" {
  type = string
}

variable "at_rest_encryption_enabled" {
  type    = bool
  default = false
}

variable "transit_encryption_enabled" {
  type    = bool
  default = false
}

variable "auth_token" {
  type    = string
  default = null
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "engine_version" {
  type = string
}

variable "port" {
  type    = number
  default = 6379
}

variable "subnet_group_name" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "maintenance_window" {
  type    = string
  default = null
}

variable "snapshot_window" {
  type    = string
  default = null
}

variable "snapshot_retention_limit" {
  type    = number
  default = 0
}

variable "cluster_mode" {
  type = object({
    replicas_per_node_group = number
    num_node_groups         = number
  })
  default = null
}

variable "parameter_group_name" {
  type    = string
  default = null
}

variable "alarm_options" {
  type = object({
    enabled       = bool
    alarm_actions = list(string)
    ok_actions    = list(string)
    node_vcpu     = number
  })
  default = {
    enabled       = false
    node_vcpu     = 1
    alarm_actions = []
    ok_actions    = []
  }
}
