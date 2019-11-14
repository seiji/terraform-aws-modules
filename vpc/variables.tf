variable "region" {
  type        = string
}

variable "namespace" {}
variable "stage" {}
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
  default = false
}

variable "use_endpoint_ssm" {
  default = false
}


variable "use_endpoint_ssm_messages" {
  default = false
}

variable "use_endpoint_ec2" {
  default = false
}

variable "use_endpoint_ec2_messages" {
  default = false
}

variable "use_endpoint_logs" {
  default = false
}

variable "use_endpoint_monitoring" {
  default = false
}
