variable service {
  type = string
}

variable env {
  type = string
}

variable attributes {
  type    = list(string)
  default = []
}

variable name {
  type    = string
  default = ""
}

variable default {
  type    = bool
  default = false
}

variable vpc_id {
  type = string
}

variable cidr_block {
  type = string
}

variable availability_zone {
  type = string
}

variable map_public_ip_on_launch {
  type    = bool
  default = false
}

variable route_table_id {
  type    = string
  default = null
}
