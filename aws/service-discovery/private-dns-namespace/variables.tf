variable "service" {
  type = string
}

variable "env" {
  type = string
}

variable "attributes" {
  type    = list(string)
  default = []
}

variable "name" {
  type    = string
  default = ""
}

variable "add_tags" {
  type    = map(string)
  default = {}
}

variable "description" {
  type    = string
  default = "Managed by Terraform"
}

variable "vpc_id" {
  type = string
}
