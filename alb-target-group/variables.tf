variable namespace {
  type = string
}

variable stage {
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

variable target_type {
  default = "instance"
}

variable stickiness_type {
  default = "lb_cookie"
}

variable stickiness_enabled {
  default = false
}
