variable "namespace" {
  type = string
}

variable "stage" {
  type = string
}

variable "attributes" {
  default = []
}

variable "vpc_id" {
  type = string
}

variable "cidr_blocks" {
  type = list(any)
}
