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

variable cidr_block {
  type = string
}
