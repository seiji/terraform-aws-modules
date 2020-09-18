variable service {
  type = string
}

variable env {
  type = string
}

variable name {
  type    = string
  default = ""
}

variable attributes {
  type    = list(string)
  default = []
}

variable delimiter {
  type    = string
  default = "-"
}

variable prefix {
  type    = string
  default = ""
}

variable add_tags {
  type    = map(string)
  default = {}
}
