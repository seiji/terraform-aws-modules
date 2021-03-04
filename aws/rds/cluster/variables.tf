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

variable "availability_zones" {
  type = list(string)
}

variable "auto_minor_version_upgrade" {
  type    = bool
  default = true
}

variable "backup_retention_period" {
  type = number
}

variable "copy_tags_to_snapshot" {
  type    = bool
  default = true
}

variable "database_name" {
  type    = string
  default = null
}

variable "db_cluster_parameter_group_name" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}

variable "deletion_protection" {
  type    = bool
  default = true
}

variable "enabled_cloudwatch_logs_exports" {
  type    = list(string)
  default = []
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "iam_database_authentication_enabled" {
  type    = bool
  default = null
}

variable "iam_roles" {
  type    = list(string)
  default = []
}

variable "instances" {
  type = list(object({
    class                        = string
    db_parameter_group_name      = string
    identifier                   = string
    monitoring_interval          = number
    monitoring_role_arn          = string
    performance_insights_enabled = bool
    preferred_backup_window      = string
    preferred_maintenance_window = string
    promotion_tier               = number
    publicly_accessible          = bool
  }))
}

variable "preferred_backup_window" {
  type = string
}

variable "preferred_maintenance_window" {
  type = string
}

variable "master_password" {
  type = string
}

variable "master_username" {
  type = string
}

variable "skip_final_snapshot" {
  type    = bool
  default = false
}

variable "storage_type" {
  type    = string
  default = "gp2"
}

variable "vpc_security_group_ids" {
  type    = list(string)
  default = []
}
