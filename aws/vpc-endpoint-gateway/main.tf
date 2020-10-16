module label {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
}

data aws_vpc_endpoint_service this {
  service = var.endpoint_service
}

resource aws_vpc_endpoint this {
  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.this.service_name
  vpc_endpoint_type = "Gateway"
  tags              = module.label.tags
}

resource aws_vpc_endpoint_route_table_association this {
  count           = length(var.route_table_ids)
  vpc_endpoint_id = aws_vpc_endpoint.this.id
  route_table_id  = var.route_table_ids[count.index]
}
