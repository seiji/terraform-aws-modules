variable "region" {
  type = string
}

variable "namespace" {
  type = string
}

variable "stage" {
  type = string
}

variable "engine_version" {
  default = "5.7.mysql_aurora.2.03.2"
}

variable "subnet_group_name" {
  type = string
}

variable "name" {
  type = string
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
  default = 7
}

variable "instance_class" {
  default = "db.t3.small"
}

variable "instance_count" {
  default = "2"
}
