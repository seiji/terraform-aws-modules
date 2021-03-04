module "label" {
  source     = "../../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

resource "aws_rds_cluster" "this" {
  availability_zones                  = var.availability_zones
  backup_retention_period             = var.backup_retention_period
  cluster_identifier                  = module.label.id
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  database_name                       = var.database_name
  db_cluster_parameter_group_name     = var.db_cluster_parameter_group_name
  db_subnet_group_name                = var.db_subnet_group_name
  deletion_protection                 = var.deletion_protection
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  engine                              = var.engine
  engine_mode                         = "provisioned"
  engine_version                      = var.engine_version
  iam_roles                           = var.iam_roles
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  master_password                     = var.master_password
  master_username                     = var.master_username
  preferred_backup_window             = var.preferred_backup_window
  preferred_maintenance_window        = var.preferred_maintenance_window
  skip_final_snapshot                 = true
  storage_encrypted                   = true
  vpc_security_group_ids              = var.vpc_security_group_ids
  lifecycle {
    ignore_changes = [availability_zones]
  }
  tags = module.label.tags
}


resource "aws_rds_cluster_instance" "this" {
  count                        = length(var.instances)
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  cluster_identifier           = aws_rds_cluster.this.id
  copy_tags_to_snapshot        = false
  db_parameter_group_name      = var.instances[count.index].db_parameter_group_name
  db_subnet_group_name         = var.db_subnet_group_name
  engine                       = var.engine
  engine_version               = var.engine_version
  identifier                   = var.instances[count.index].identifier
  instance_class               = var.instances[count.index].class
  monitoring_interval          = var.instances[count.index].monitoring_interval
  monitoring_role_arn          = var.instances[count.index].monitoring_role_arn
  performance_insights_enabled = var.instances[count.index].performance_insights_enabled
  preferred_backup_window      = var.instances[count.index].preferred_backup_window
  preferred_maintenance_window = var.instances[count.index].preferred_maintenance_window
  promotion_tier               = var.instances[count.index].promotion_tier
  publicly_accessible          = var.instances[count.index].publicly_accessible
  depends_on                   = [aws_rds_cluster.this]
  lifecycle {
    ignore_changes = [availability_zone]
  }
  tags = merge(module.label.tags, { Name = var.instances[count.index].identifier })
}
