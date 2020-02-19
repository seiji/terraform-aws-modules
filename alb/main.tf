locals {
  ssl_policy = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
}

module "label" {
  source    = "../label"
  namespace = var.namespace
  stage     = var.stage
}

resource "aws_alb" "this" {
  name            = module.label.id
  internal        = false
  security_groups = var.security_groups
  subnets         = var.subnets
  idle_timeout    = 60

  tags = module.label.tags
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = local.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.this.arn
    type             = "forward"
  }

  depends_on = [
    aws_alb.this,
    aws_alb_target_group.this,
  ]
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

  depends_on = [
    aws_alb.this,
  ]
}

resource "aws_alb_target_group" "this" {
  name        = module.label.id
  port        = var.tg_port
  protocol    = var.tg_protocol
  target_type = var.tg_target_type
  vpc_id      = var.vpc_id
  dynamic health_check {
    for_each = [for hc in var.tg_health_check.enabled ? [var.tg_health_check] : [] : {
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
  dynamic stickiness {
    for_each = [for stk in var.tg_stickiness.enabled ? [var.tg_stickiness] : [] : {
      type            = stk.type
      cookie_duration = stk.cookie_duration
    }]
    content {
      type            = stickiness.value.type
      cookie_duration = stickiness.value.cookie_duration
      enabled         = true
    }
  }

  depends_on = [
    aws_alb.this,
  ]
  tags = module.label.tags
}
