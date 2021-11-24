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
  type = list(any)
}

variable "subnet_public_id_list" {
  type = list(any)
}

variable "alb_security_id_list" {
  type = list(any)
}

variable "ec2_security_id_list" {
  type = list(any)
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
  default = ""
}

variable "userdata_part_content_type" {
  default = "text/cloud-config"
}

variable "userdata_part_merge_type" {
  default = "list(append)+dict(recurse_array)+str()"
}

variable "acm_arn" {}
