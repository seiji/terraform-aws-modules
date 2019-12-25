resource aws_alb this {
  name            = module.label.id
  internal        = false
  security_groups = var.alb_security_ids
  subnets         = var.subnet_public_ids
  idle_timeout    = 60
}

resource aws_alb_listener this {
  load_balancer_arn = aws_alb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = var.acm_arn

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

resource aws_alb_target_group this {
  name     = module.label.id
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }

  stickiness {
    type    = "lb_cookie"
    enabled = true
  }
}