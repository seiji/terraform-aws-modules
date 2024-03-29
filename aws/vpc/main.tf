module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
}

resource "aws_default_vpc" "this" {
  count                = var.default ? 1 : 0
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = merge(module.label.tags, var.add_tags)
}

resource "aws_vpc" "this" {
  count                = var.default ? 0 : 1
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = merge(module.label.tags, var.add_tags)
}

locals {
  vpc = var.default ? aws_default_vpc.this[0] : aws_vpc.this[0]
}

resource "aws_internet_gateway" "this" {
  vpc_id = local.vpc.id
  tags   = merge(module.label.tags, { Name = join("-", [var.name, "igw"]) })
}

resource "aws_default_security_group" "this" {
  vpc_id = local.vpc.id
  tags   = module.label.tags
}

