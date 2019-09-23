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

