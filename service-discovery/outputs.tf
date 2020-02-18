output "namespace_name" {
  value = aws_service_discovery_private_dns_namespace.this.name
}

output "namespace_id" {
  value = aws_service_discovery_private_dns_namespace.this.id
}
