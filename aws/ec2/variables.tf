variable "region" {
  description = "region"
  type        = string
  default     = "ap-northeast-1"
}

variable "service" {}
variable "env" {}
variable "name" {}

variable "instance_type" {}
variable "associate_public_ip_address" {
  type = bool
  default = false
}
variable "subnet_id_list" {
  type = list
}
variable "security_id_list" {
  type = list
}

variable "key_name" {}
variable "user_data" {
  default = ""
}
