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

variable internal {
  type    = bool
  default = false
}

variable load_balancer_type {
  type    = string
  default = "application"
}

variable access_logs {
  type = object({
    bucket  = string
    enabled = bool
    prefix  = string
  })
  default = {
    bucket  = ""
    enabled = false
    prefix  = ""
  }
}

variable subnets {
  type = list(string)
}

variable security_groups {
  default = []
}

variable idle_timeout {
  type    = number
  default = 60
}

variable vpc_id {
  type = string
}

variable ssl_policy {
  type    = string
  default = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
}

variable listener {
  type = object({
    certificate_arn = string
    default_action = object({
      type = string
      name = string
      fixed_response = object({
        content_type = string
        message_body = string
        status_code  = string
      })
    })
    rules = list(object({
      priority = number
      action = object({
        type = string
        name = string
        fixed_response = object({
          content_type = string
          message_body = string
          status_code  = string
        })
      })
      condition = object({
        http_header = object({
          http_header_name = string
          values           = list(string)
        })
        path_pattern = object({
          values = list(string)
        })
        source_ip = object({
          values = list(string)
        })
      })
    }))
  })
}

variable target_group {
  type = map(object({
    deregistration_delay = number
    health_check = object({
      enabled             = bool
      healthy_threshold   = number
      interval            = number
      path                = string
      port                = string
      timeout             = number
      unhealthy_threshold = number
    })
    port        = number
    target_type = string
  }))
  default = {
    default = {
      deregistration_delay = 300
      health_check = {
        enabled             = false
        healthy_threshold   = 3
        interval            = 30
        path                = null
        port                = "traffic-port"
        timeout             = 5
        unhealthy_threshold = 3
      }
      port = null
      stickiness = {
        cookie_duration = 86400
        enabled         = false
        type            = "lb_cookie"
      }
      target_type = "instance"
    }
  }
}
