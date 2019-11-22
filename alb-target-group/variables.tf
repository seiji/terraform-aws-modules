variable namespace {
  type = string
}

variable stage {
  type = string
}

variable name {
  type = string
}

variable vpc_id {
  type = string
}

variable port {
  type = number
}

variable protocol {
  default = "TCP"
}

variable health_check_path {
  default = "/"
}

