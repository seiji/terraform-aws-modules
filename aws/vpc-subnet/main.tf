module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  add_tags   = var.add_tags
  name       = var.name
}

resource "aws_default_subnet" "this" {
  count                   = var.default ? 1 : 0
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags                    = module.label.tags
}

resource "aws_subnet" "this" {
  count                   = var.default ? 0 : 1
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags                    = module.label.tags
}

locals {
  subnet = var.default ? aws_default_subnet.this[0] : aws_subnet.this[0]
}

resource "aws_route_table_association" "this" {
  count          = var.route_table_id == null ? 0 : 1
  route_table_id = var.route_table_id
  subnet_id      = local.subnet.id
}
