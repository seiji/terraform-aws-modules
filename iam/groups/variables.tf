variable groups {
  type = map(list(string))
}

variable group_path {
  type    = string
  default = "/"
}

variable users {
  type = map(list(string))
}

variable user_path {
  type    = string
  default = "/"
}

