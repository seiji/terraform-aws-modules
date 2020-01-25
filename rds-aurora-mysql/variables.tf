variable "namespace" {
  type = string
}

variable "stage" {
  type = string
}

variable "engine_version" {
  default = "5.7.mysql_aurora.2.07.1"
}

variable "subnet_ids" {
  type = list(string)
}

variable "database_name" {
  type = string
}

variable "master_username" {
  type = string
}

variable "master_password" {
  type = string
}

variable "backup_retention_period" {
  default = 1
}

variable "vpc_security_group_ids" {
  default = []
}

variable "instance_class" {
  default = "db.t3.small"
}

variable "instance_count" {
  default = 2
}

variable "publicly_accessible" {
  default = false
}

