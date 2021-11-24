module "label" {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  attributes = var.attributes
}

resource "aws_security_group" "this" {
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

resource "aws_security_group_rule" "this" {
  for_each = { for r in var.rules : index(var.rules, r) => r }

  security_group_id        = aws_security_group.this.id
  type                     = "ingress"
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = each.value.cidr_blocks
  source_security_group_id = each.value.source_security_group_id
  self                     = each.value.self
}
