variable "region" {
  description = "region"
  type        = string
  default     = "ap-northeast-1"
}

variable "service" {}
variable "env" {}
variable "name" {}

variable "image_id" {}
variable "instance_type" {}
variable "associate_public_ip_address" {
  type    = bool
  default = false
}

variable "vpc_id" {}
variable "subnet_private_id_list" {
  type = list
}

variable "subnet_public_id_list" {
  type = list
}
variable "security_id_list" {
  type = list
}

variable "key_name" {}
variable "user_data" {
  type    = string
  default = false
}

variable "use_cloudwatch_agent" {
  default = false
}

variable "metrics_collection_interval" {
  type    = number
  default = 60
}

variable "userdata_part_content" {
  type    = string
  default = ""
}

variable "userdata_part_content_type" {
  type    = string
  default = "text/cloud-config"
}

variable "userdata_part_merge_type" {
  type    = string
  default = "list(append)+dict(recurse_array)+str()"
}
