variable namespace {
  type = string
}

variable stage {
  type = string
}

variable attributes {
  default = []
}

variable vpc_id {
  type = string
}

variable from_port {
  type = number
}

variable to_port {
  type = number
}

variable protocol {
  type = string
}

variable cidr_blocks {
  type = list
}
