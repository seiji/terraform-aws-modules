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

variable "vpc_id" {
  type = string
}

variable "default" {
  type    = bool
  default = false
}

variable "propagating_vgws" {
  type    = list(string)
  default = null
}

variable "routes" {
  type = list(object({
    cidr_block                = string
    egress_only_gateway_id    = string
    gateway_id                = string
    instance_id               = string
    ipv6_cidr_block           = string
    nat_gateway_id            = string
    network_interface_id      = string
    transit_gateway_id        = string
    vpc_peering_connection_id = string
  }))
  default = []
}
