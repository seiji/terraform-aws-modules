variable namespace {
  type = string
}

variable stage {
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
  default = "-"
}

variable tags {
  type = map(string)
  default = {
  }
}
