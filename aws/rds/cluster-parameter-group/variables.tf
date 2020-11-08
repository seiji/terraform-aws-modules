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

variable add_tags {
  type    = map(string)
  default = {}
}

variable family {
  type = string
}

variable description {
  type    = string
  default = null
}

variable parameters {
  type = list(object({
    name         = string
    value        = string
    apply_method = string
  }))
  default = []
}
