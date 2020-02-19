variable namespace {
  type = string
}

variable stage {
  type = string
}

variable vpc_id {
  type = string
}

variable subnets {
  type = list
}

variable security_groups {
  default = []
}

variable certificate_arn {
  type = string
}

variable tg_port {
  type = number
}

variable tg_protocol {
  default = "TCP"
}

variable tg_target_type {
  default = "instance"
}

variable tg_health_check {
  type = object({
    enabled             = bool
    health_threshold    = number
    interval            = number
    path                = string
    timeout             = number
    unhealthy_threshold = number
  })
  default = {
    enabled             = false
    health_threshold    = 3
    interval            = 30
    path                = null
    timeout             = 5
    unhealthy_threshold = 3
  }
}

variable tg_stickiness {
  type = object({
    cookie_duration = number
    enabled         = bool
    type            = string
  })
  default = {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }
}

