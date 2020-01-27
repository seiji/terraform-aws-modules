module "label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  stage     = var.stage
}

resource "aws_alb_target_group" "this" {
  name        = module.label.id
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    interval            = 30
    path                = var.health_check_path
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }

  stickiness {
    type    = var.stickiness_type
    enabled = var.stickiness_enabled
  }

  tags = module.label.tags
}
