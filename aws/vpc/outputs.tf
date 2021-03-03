output id {
  value = local.vpc.id
}

output cidr_block {
  value = local.vpc.cidr_block
}

output default_route_table_id {
  value = local.vpc.default_route_table_id
}

output default_security_group_id {
  value = aws_default_security_group.this.id
}

output internet_gateway_id {
  value = aws_internet_gateway.this.id
}
