variable namespace {
  type = string
}

variable stage {
  type = string
}

variable attributes {
  default = []
}

variable service {
  type = string
}

variable vpc_id {
  type = string
}

variable private_dns_enabled {
  type    = bool
  default = false
}

variable subnet_ids {
  type    = list(string)
  default = []
}

variable security_group_ids {
  type    = list(string)
  default = []
}

variable vpc_endpoint_type {
  type    = string
  default = "Gateway"
}
