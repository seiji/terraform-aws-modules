variable "namespace" {}
variable "stage" {}
variable "attributes" {
  default = []
}

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

variable "alb_security_id_list" {
  type = list
}

variable "ec2_security_id_list" {
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
