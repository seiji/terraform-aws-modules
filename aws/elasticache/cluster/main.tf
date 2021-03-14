module "label" {
  source     = "../../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_description = var.description
  replication_group_id          = module.label.id
  number_cache_clusters         = var.number_cache_clusters
  node_type                     = var.node_type
  automatic_failover_enabled    = var.automatic_failover_enabled
  auto_minor_version_upgrade    = true
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled
  auth_token                    = var.auth_token
  kms_key_id                    = var.kms_key_id
  engine_version                = var.engine_version
  parameter_group_name          = var.parameter_group_name
  port                          = var.port
  subnet_group_name             = var.subnet_group_name
  security_group_ids            = var.security_group_ids
  maintenance_window            = var.maintenance_window
  snapshot_window               = var.snapshot_window
  snapshot_retention_limit      = var.snapshot_retention_limit
  apply_immediately             = true

  dynamic "cluster_mode" {
    for_each = [for m in var.cluster_mode != null ? [var.cluster_mode] : [] : m]
    content {
      replicas_per_node_group = cluster_mode.value.replicas_per_node_group
      num_node_groups         = cluster_mode.value.num_node_groups
    }
  }
  tags = module.label.tags
}
