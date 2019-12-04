module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace  = var.namespace
  stage      = var.stage
  attributes = var.attributes
}

resource aws_security_group this {
  name   = module.label.id
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.label.tags
}

resource aws_security_group_rule this {
  security_group_id = aws_security_group.this.id

  type = "ingress"

  from_port   = var.from_port
  to_port     = var.to_port
  protocol    = var.protocol
  cidr_blocks = var.cidr_blocks
}
