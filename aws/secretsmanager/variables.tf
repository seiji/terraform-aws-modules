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

variable add_tags {
  type    = map(string)
  default = {}
}

variable description {
  type    = string
  default = null
}

variable kms_key_id {
  type    = string
  default = null
}

variable recovery_window_in_days {
  type    = number
  default = null
}
