output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "service_name" {
  value = aws_ecs_service.this.name
}

output "service_discovery_service_arn" {
  value = var.service_discovery != null ? aws_service_discovery_service.this[0].arn : null
}
