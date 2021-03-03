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

variable "endpoint_service" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "route_table_ids" {
  type = list(string)
}
