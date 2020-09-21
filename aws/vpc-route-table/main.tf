module label {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
}

data aws_vpc this {
  id = var.vpc_id
}

resource aws_default_route_table this {
  count                  = var.default ? 1 : 0
  default_route_table_id = data.aws_vpc.this.main_route_table_id
  propagating_vgws       = var.propagating_vgws
  dynamic route {
    for_each = var.routes
    content {
      cidr_block                = route.value.cidr_block
      egress_only_gateway_id    = route.value.egress_only_gateway_id
      gateway_id                = route.value.gateway_id
      instance_id               = route.value.instance_id
      ipv6_cidr_block           = route.value.ipv6_cidr_block
      nat_gateway_id            = route.value.nat_gateway_id
      network_interface_id      = route.value.network_interface_id
      transit_gateway_id        = route.value.transit_gateway_id
      vpc_peering_connection_id = route.value.vpc_peering_connection_id
    }
  }
  tags       = module.label.tags
  depends_on = [data.aws_vpc.this]
}

resource aws_route_table this {
  count  = var.default ? 0 : 1
  vpc_id = var.vpc_id
  dynamic route {
    for_each = var.routes
    content {
      cidr_block                = route.value.cidr_block
      egress_only_gateway_id    = route.value.egress_only_gateway_id
      gateway_id                = route.value.gateway_id
      instance_id               = route.value.instance_id
      ipv6_cidr_block           = route.value.ipv6_cidr_block
      nat_gateway_id            = route.value.nat_gateway_id
      network_interface_id      = route.value.network_interface_id
      transit_gateway_id        = route.value.transit_gateway_id
      vpc_peering_connection_id = route.value.vpc_peering_connection_id
    }
  }
  tags = module.label.tags
}

locals {
  route_table = var.default ? aws_default_route_table.this[0] : aws_route_table.this[0]
}
