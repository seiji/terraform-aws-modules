output "id" {
  value = aws_elasticache_replication_group.this.id
}

output "port" {
  value = var.port
}

output "primary_endpoint_address" {
  value = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "reader_endpoint_address" {
  value = "${aws_elasticache_replication_group.this.id}-ro.${
    join(".",
      slice(
        split(".", aws_elasticache_replication_group.this.primary_endpoint_address),
        1,
        length(split(".", aws_elasticache_replication_group.this.primary_endpoint_address))
      )
    )
  }"
}

output "member_clusters" {
  value = aws_elasticache_replication_group.this.member_clusters
}
