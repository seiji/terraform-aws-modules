module label {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
}

resource aws_security_group this {
  count       = var.default ? 0 : 1
  name        = module.label.id
  vpc_id      = var.vpc_id
  description = var.description
  tags        = module.label.tags
}

resource aws_default_security_group this {
  count  = var.default ? 1 : 1
  vpc_id = var.vpc_id
  tags   = module.label.tags
}

locals {
  security_group = var.default ? aws_default_security_group.this[0] : aws_security_group.this[0]
}

resource aws_security_group_rule this {
  for_each                 = { for r in var.rules : index(var.rules, r) => r }
  security_group_id        = local.security_group.id
  description              = each.value.description
  type                     = "ingress"
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = each.value.cidr_blocks
  source_security_group_id = each.value.source_security_group_id
  self                     = each.value.self
  depends_on               = [local.security_group]
}


resource aws_security_group_rule egress {
  security_group_id = local.security_group.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  self              = false
  depends_on        = [local.security_group]
}
