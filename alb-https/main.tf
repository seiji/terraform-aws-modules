locals {
  ssl_policy = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
}

module "label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  stage     = var.stage
  delimiter = "-"
}

resource "aws_alb" "this" {
  name            = var.name
  internal        = false
  security_groups = var.security_groups
  subnets         = var.subnets
  idle_timeout    = 60

  tags = module.label.tags
}


resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_alb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = local.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    target_group_arn = var.target_group_arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect  {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
