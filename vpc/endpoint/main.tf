module "label" {
  source     = "../../label"
  namespace  = var.namespace
  stage      = var.stage
  attributes = var.attributes
}

data "aws_vpc_endpoint_service" "this" {
  service = var.service
}

resource "aws_vpc_endpoint" "this" {
  vpc_id              = var.vpc_id
  service_name        = data.aws_vpc_endpoint_service.this.service_name
  vpc_endpoint_type   = var.vpc_endpoint_type
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.subnet_ids
  private_dns_enabled = var.private_dns_enabled
  tags                = module.label.tags
  depends_on          = [data.aws_vpc_endpoint_service.this]
}

