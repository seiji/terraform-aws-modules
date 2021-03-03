locals {
  action_type = {
    forward              = "forward"
    redirect             = "redirect"
    fixed_response       = "fixed-response"
    authenticate_cognito = "authenticate-cognito"
    authenticate_oidc    = "authenticate-oidc"
  }
}

module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

resource "aws_alb" "this" {
  name            = module.label.id
  internal        = var.internal
  security_groups = var.security_groups
  subnets         = var.subnets
  dynamic "access_logs" {
    for_each = var.access_logs != null ? [var.access_logs] : []
    content {
      bucket  = access_logs.value.bucket
      enabled = access_logs.value.enabled
      prefix  = access_logs.value.prefix
    }
  }
  idle_timeout = var.idle_timeout
  tags         = module.label.tags
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.listener.certificate_arn

  dynamic "default_action" {
    for_each = [var.listener.default_action]
    content {
      type             = default_action.value.type
      target_group_arn = default_action.value.type == local.action_type.forward ? aws_alb_target_group.this[default_action.value.name].arn : null
      dynamic "fixed_response" {
        for_each = default_action.value.fixed_response != null ? [default_action.value.fixed_response] : []
        content {
          content_type = fixed_response.value.content_type
          message_body = fixed_response.value.message_body
          status_code  = fixed_response.value.status_code
        }
      }
    }
  }
  depends_on = [aws_alb.this, ]
}

resource "aws_alb_listener_rule" "https" {
  for_each     = { for r in var.listener.rules : r.priority => r }
  listener_arn = aws_alb_listener.https.arn
  priority     = each.value.priority

  dynamic "action" {
    for_each = [each.value.action]
    content {
      type             = action.value.type
      target_group_arn = action.value.type == local.action_type.forward ? aws_alb_target_group.this[action.value.name].arn : null
      dynamic "fixed_response" {
        for_each = action.value.fixed_response != null ? [action.value.fixed_response] : []
        content {
          content_type = fixed_response.value.content_type
          message_body = fixed_response.value.message_body
          status_code  = fixed_response.value.message_body
        }
      }
    }
  }
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      dynamic "http_header" {
        for_each = condition.value.http_header != null ? [condition.value.http_header] : []
        content {
          http_header_name = http_header.value.http_header_name
          values           = http_header.value.values
        }
      }
      dynamic "host_header" {
        for_each = condition.value.host_header != null ? [condition.value.host_header] : []
        content {
          values = host_header.value.values
        }
      }
      dynamic "path_pattern" {
        for_each = condition.value.path_pattern != null ? [condition.value.path_pattern] : []
        content {
          values = path_pattern.value.values
        }
      }
      dynamic "source_ip" {
        for_each = condition.value.source_ip != null ? [condition.value.source_ip] : []
        content {
          values = source_ip.value.values
        }
      }
    }
  }

  depends_on = [aws_alb_listener.https, ]
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  depends_on = [aws_alb.this, ]
}

resource "aws_alb_target_group" "this" {
  for_each             = var.target_group
  name                 = each.key == "default" ? module.label.id : join(module.label.delimiter, [module.label.id, each.key])
  deregistration_delay = each.value.deregistration_delay
  port                 = each.value.port
  protocol             = "HTTP"
  target_type          = each.value.target_type
  vpc_id               = var.vpc_id

  dynamic "health_check" {
    for_each = [for hc in each.value.health_check.enabled ? [each.value.health_check] : [] : {
      interval            = hc.interval
      path                = hc.path
      timeout             = hc.timeout
      healthy_threshold   = hc.healthy_threshold
      unhealthy_threshold = hc.unhealthy_threshold
    }]
    content {
      enabled             = true
      interval            = health_check.value.interval
      path                = health_check.value.path
      timeout             = health_check.value.timeout
      healthy_threshold   = health_check.value.healthy_threshold
      unhealthy_threshold = health_check.value.unhealthy_threshold
    }
  }
  depends_on = [aws_alb.this, ]
  tags       = module.label.tags
}
