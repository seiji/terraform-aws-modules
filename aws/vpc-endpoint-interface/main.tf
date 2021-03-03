module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
}

data "aws_vpc_endpoint_service" "this" {
  service      = var.endpoint_service
  service_type = "Interface"
}

resource "aws_vpc_endpoint" "this" {
  vpc_id              = var.vpc_id
  service_name        = data.aws_vpc_endpoint_service.this.service_name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.subnet_ids
  private_dns_enabled = var.private_dns_enabled
  tags                = module.label.tags
}
