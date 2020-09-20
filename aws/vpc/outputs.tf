output id {
  value = local.vpc.id
}

output default_route_table_id {
  value = local.vpc.default_route_table_id
}

output internet_gateway_id {
  value = aws_internet_gateway.this.id
}
