module "label" {
  source     = "../../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

resource "aws_elasticache_subnet_group" "this" {
  name       = module.label.id
  subnet_ids = var.subnet_ids
}
