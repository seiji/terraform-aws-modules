resource "aws_rds_cluster" "this" {
  cluster_identifier      = var.name
  engine                  = "aurora-mysql"
  engine_version          = var.engine_version
  database_name           = var.database_name
  db_subnet_group_name    = var.subnet_group_name
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = "07:00-09:00"
}

resource "aws_rds_cluster_instance" "this" {
  count              = var.instance_count
  engine             = "aurora-mysql"
  engine_version     = var.engine_version
  identifier         = "${var.name}-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_class
}
