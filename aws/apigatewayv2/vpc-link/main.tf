module "label" {
  source     = "../../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

resource "aws_apigatewayv2_vpc_link" "this" {
  for_each           = var.vpc_links
  name               = module.label.id
  security_group_ids = each.value.security_group_ids
  subnet_ids         = each.value.subnet_ids
  tags               = module.label.tags
}
