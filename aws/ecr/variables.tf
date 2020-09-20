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

variable lifecycle_policy_json {
  type    = string
  default = null
}

