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

variable rules {
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = list(string)
    source_security_group_id = string
    self                     = bool
  }))
}
