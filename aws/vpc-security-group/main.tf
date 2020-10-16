module label {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
}

resource aws_security_group this {
  name        = module.label.id
  vpc_id      = var.vpc_id
  description = var.description
  tags        = module.label.tags
}

resource aws_security_group_rule this {
  for_each                 = { for r in var.rules : index(var.rules, r) => r }
  security_group_id        = aws_security_group.this.id
  description              = each.value.description
  type                     = "ingress"
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = each.value.cidr_blocks
  source_security_group_id = each.value.source_security_group_id
  self                     = each.value.self
  depends_on               = [aws_security_group.this]
}

resource aws_security_group_rule egress {
  security_group_id = aws_security_group.this.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  self              = false
  depends_on        = [aws_security_group.this]
}
