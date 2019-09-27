variable "region" {
  description = "region"
  type        = string
  default     = "ap-northeast-1"
}

variable "service" {}
variable "env" {}
variable "cidr_block" {}
variable "azs" {
  type = list
}
variable "private_subnets" {
  type = list
}
variable "public_subnets" {
  type = list
}

variable "use_natgw" {
  type    = bool
  default = false
}

variable "use_endpoint_ssm" {
  type    = bool
  default = false
}


variable "use_endpoint_ssm_messages" {
  type    = bool
  default = false
}

variable "use_endpoint_ec2" {
  type    = bool
  default = false
}

variable "use_endpoint_ec2_messages" {
  type    = bool
  default = false
}

variable "use_endpoint_logs" {
  type    = bool
  default = false
}

variable "use_endpoint_monitoring" {
  type    = bool
  default = false
}
