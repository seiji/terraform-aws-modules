module "label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  stage     = var.stage
  delimiter = "-"
}

resource "aws_alb_target_group" "this" {
  name     = var.name
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    path                = var.health_check_path
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }

  stickiness {
    type    = "lb_cookie"
    enabled = true
  }

  tags = module.label.tags
}
