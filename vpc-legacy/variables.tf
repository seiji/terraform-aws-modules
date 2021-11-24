variable "region" {
  default = "ap-northeast-1"
}

variable "namespace" {}
variable "stage" {}

variable "cidr_block" {}

variable "azs" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}
