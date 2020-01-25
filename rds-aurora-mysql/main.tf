module label {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  stage     = var.stage
}

data "aws_iam_role" "aws_service_role_for_rds" {
  name = "AWSServiceRoleForRDS"
}

resource "aws_rds_cluster" "this" {
  cluster_identifier      = module.label.id
  copy_tags_to_snapshot   = true
  database_name           = var.database_name
  deletion_protection     = false
  db_subnet_group_name    = aws_db_subnet_group.this.name
  master_password         = var.master_password
  master_username         = var.master_username
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = "07:00-09:00"
  storage_encrypted       = false
  # db_cluster_parameter_group_name
  iam_roles                       = [data.aws_iam_role.aws_service_role_for_rds.arn]
  engine                          = "aurora-mysql"
  engine_mode                     = "provisioned"
  engine_version                  = var.engine_version
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  depends_on = [
    data.aws_iam_role.aws_service_role_for_rds,
  ]

  lifecycle {
    ignore_changes = [availability_zones]
  }
  tags = module.label.tags
}

resource "aws_rds_cluster_instance" "this" {
  count              = var.instance_count
  cluster_identifier = aws_rds_cluster.this.id
  engine             = "aurora-mysql"
  engine_version     = var.engine_version
  identifier         = join("-", [module.label.id, count.index])
  instance_class     = var.instance_class
}

resource "aws_db_subnet_group" "this" {
  name       = module.label.id
  subnet_ids = var.subnet_ids
}
