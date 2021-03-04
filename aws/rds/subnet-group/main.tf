locals {
  description = "Managed by Terraform"
}

module "label" {
  source     = "../../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
}

resource "aws_db_subnet_group" "this" {
  name        = module.label.id
  description = var.description != null ? var.description : local.description
  subnet_ids  = var.subnet_ids
  tags        = module.label.tags
}
