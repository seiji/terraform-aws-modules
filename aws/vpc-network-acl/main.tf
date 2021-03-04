module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
}

resource "aws_default_network_acl" "this" {
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
  tags       = module.label.tags
}

resource "aws_network_acl" "this" {
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
  tags       = module.label.tags
}
resource "aws_network_acl" "this" {
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
  tags       = module.label.tags
}

resource "aws_network_acl_rule" "igress" {
  for_each       = { for r in var.igress : r.rule_number => r }
  network_acl_id = aws_network_acl.this.id
  egress         = false
  rule_action    = "allow"
  rule_number    = each.value.rule_number
  protocol       = each.value.protocol
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
  depends_on     = [aws_network_acl.this]
}

resource "aws_network_acl_rule" "egress" {
  for_each       = { for r in var.egress : r.rule_number => r }
  network_acl_id = aws_network_acl.this.id
  egress         = true
  rule_action    = "allow"
  rule_number    = each.value.rule_number
  protocol       = each.value.protocol
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
  depends_on     = [aws_network_acl.this]
}
