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

variable "at_rest_encryption_enabled" {
  type    = bool
  default = false
}

variable "auth_token" {
  type    = string
  default = null
}

variable "automatic_failover_enabled" {
  type    = bool
  default = false
}

variable "cluster_mode" {
  type = object({
    replicas_per_node_group = number
    num_node_groups         = number
  })
  default = null
}

variable "engine_version" {
  type = string
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "maintenance_window" {
  type    = string
  default = null
}

variable "number_cache_clusters" {
  type = number
}

variable "node_type" {
  type = string
}

variable "notification_topic_arn" {
  type    = string
  default = null
}

variable "port" {
  type    = number
  default = 6379
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_group_name" {
  type = string
}

variable "snapshot_window" {
  type    = string
  default = null
}

variable "snapshot_retention_limit" {
  type    = number
  default = 0
}

variable "transit_encryption_enabled" {
  type    = bool
  default = false
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
