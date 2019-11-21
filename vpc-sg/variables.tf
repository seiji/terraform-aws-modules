variable "region" {
  description = "region"
  type        = string
  default     = "ap-northeast-1"
}

variable "namespace" {}
variable "stage" {}
variable "name" {}
variable "vpc_id" {}
variable "from_port" {
  type = number
}
variable "to_port" {
  type = number
}
variable "protocol" {}
variable "cidr_blocks" {
  type = list
}
