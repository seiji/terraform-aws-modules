module "label" {
  source     = "../../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = module.label.id
  description = var.description
  vpc         = var.vpc_id
}

