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

variable path {
  type    = string
  default = null
}

variable principals {
  type = object({
    type        = string
    identifiers = list(string)
  })
}

variable policy_json_list {
  type    = list(string)
  default = []
}

variable policy_arn_list {
  type    = list(string)
  default = []
}
