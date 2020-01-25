module label {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  stage     = var.stage
}

data "aws_iam_role" "aws_service_role_for_rds" {
  name = "AWSServiceRoleForRDS"
}

resource "aws_rds_cluster" "this" {
  cluster_identifier              = module.label.id
  copy_tags_to_snapshot           = true
  database_name                   = var.database_name
  deletion_protection             = false
  db_subnet_group_name            = aws_db_subnet_group.this.name
  master_password                 = var.master_password
  master_username                 = var.master_username
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = "07:00-09:00"
  vpc_security_group_ids          = var.vpc_security_group_ids
  storage_encrypted               = false
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.name
  iam_roles                       = [data.aws_iam_role.aws_service_role_for_rds.arn]
  engine                          = "aurora-mysql"
  engine_mode                     = "provisioned"
  engine_version                  = var.engine_version
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  skip_final_snapshot             = true

  depends_on = [
    aws_db_subnet_group.this,
    data.aws_iam_role.aws_service_role_for_rds,
  ]
  lifecycle {
    ignore_changes = [availability_zones]
  }
  tags = module.label.tags
}

resource "aws_rds_cluster_instance" "this" {
  count = var.instance_count

  cluster_identifier    = aws_rds_cluster.this.id
  engine                = "aurora-mysql"
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  publicly_accessible   = var.publicly_accessible
  db_subnet_group_name  = aws_db_subnet_group.this.name
  copy_tags_to_snapshot = true

  depends_on = [
    aws_rds_cluster.this,
    aws_db_subnet_group.this,
  ]
  tags = module.label.tags
}


resource "aws_rds_cluster_parameter_group" "this" {
  name   = module.label.id
  family = "aurora-mysql5.7"
  #
  # parameter {
  #   name         = "server_audit_logging"
  #   value        = "1"
  # }
  #
  # parameter {
  #   name         = "server_audit_events"
  #   value        = "Connect,Query,Query_DCL,Query_DDL,Query_DML,Table"
  # }

  parameter {
    name         = "character_set_client"
    value        = "utf8"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_connection"
    value        = "utf8"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_database"
    value        = "utf8"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_results"
    value        = "utf8"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_server"
    value        = "utf8"
    apply_method = "immediate"
  }

  # parameter {
  #   name         = "collation_connection"
  #   value        = "utf8_general_ci"
  # }
  #
  # parameter {
  #   name         = "collation_server"
  #   value        = "utf8_general_ci"
  # }
  #
  # parameter {
  #   name         = "innodb_flush_log_at_trx_commit"
  #   value        = "0"
  # }
  #
  # parameter {
  #   name         = "skip-character-set-client-handshake"
  #   value        = "1"
  # }

  tags = module.label.tags
}

resource "aws_db_subnet_group" "this" {
  name       = module.label.id
  subnet_ids = var.subnet_ids
  tags       = module.label.tags
}
