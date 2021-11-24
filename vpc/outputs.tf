output "id" {
  value = aws_vpc.this.id
}

output "default_security_group_id" {
  value = aws_vpc.this.default_security_group_id
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}

output "default_route_table_private_id" {
  value = aws_default_route_table.private.id
}
