locals {
  free_storage_space_threshold = var.ebs_options.volume_size * 1024 * 0.25
  nodes_threshold              = var.cluster_config.instance_count
}

resource aws_cloudwatch_metric_alarm cluster_status_red {
  count               = var.alarm_options.enabled ? 1 : 0
  alarm_name          = join("-", [module.label.id, "es-ClusterStatusRed"])
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ClusterStatus.red"
  namespace           = "AWS/ES"
  period              = 60
  statistic           = "Maximum"
  threshold           = 1
  alarm_description   = "At least one primary shard and its replicas are not allocated to a node"
  alarm_actions       = var.alarm_options.alarm_actions
  ok_actions          = var.alarm_options.ok_actions
  treat_missing_data  = "ignore"

  dimensions = {
    ClientId   = data.aws_caller_identity.this.account_id
    DomainName = aws_elasticsearch_domain.this.domain_name
  }

  tags = module.label.tags
}

resource aws_cloudwatch_metric_alarm cluster_status_yellow {
  count               = var.alarm_options.enabled ? 1 : 0
  alarm_name          = join("-", [module.label.id, "es-ClusterStatusYellow"])
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ClusterStatus.yellow"
  namespace           = "AWS/ES"
  period              = 60
  statistic           = "Maximum"
  threshold           = 1
  alarm_description   = "At least one replica shard is not allocated to a node"
  alarm_actions       = var.alarm_options.alarm_actions
  ok_actions          = var.alarm_options.ok_actions
  treat_missing_data  = "ignore"

  dimensions = {
    ClientId   = data.aws_caller_identity.this.account_id
    DomainName = aws_elasticsearch_domain.this.domain_name
  }

  tags = module.label.tags
}

resource aws_cloudwatch_metric_alarm free_storage_space {
  count               = var.alarm_options.enabled ? 1 : 0
  alarm_name          = join("-", [module.label.id, "es-FreeStorageSpace"])
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/ES"
  period              = 60
  statistic           = "Minimum"
  threshold           = local.free_storage_space_threshold
  alarm_description   = "A node in your cluster is down to ${local.free_storage_space_threshold} MiB of free storage space."
  alarm_actions       = var.alarm_options.alarm_actions
  ok_actions          = var.alarm_options.ok_actions
  treat_missing_data  = "ignore"

  dimensions = {
    ClientId   = data.aws_caller_identity.this.account_id
    DomainName = aws_elasticsearch_domain.this.domain_name
  }

  tags = module.label.tags
}

resource aws_cloudwatch_metric_alarm cluster_index_writes_blocked {
  count               = var.alarm_options.enabled ? 1 : 0
  alarm_name          = join("-", [module.label.id, "es-ClusterIndexWritesBlocked"])
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ClusterIndexWritesBlocked"
  namespace           = "AWS/ES"
  period              = 300
  statistic           = "Maximum"
  threshold           = 1
  alarm_description   = "Your cluster is blocking write requests"
  alarm_actions       = var.alarm_options.alarm_actions
  ok_actions          = var.alarm_options.ok_actions
  treat_missing_data  = "ignore"

  dimensions = {
    ClientId   = data.aws_caller_identity.this.account_id
    DomainName = aws_elasticsearch_domain.this.domain_name
  }

  tags = module.label.tags
}

resource aws_cloudwatch_metric_alarm nodes {
  count               = var.alarm_options.enabled ? 1 : 0
  alarm_name          = join("-", [module.label.id, "es-Nodes"])
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Nodes"
  namespace           = "AWS/ES"
  period              = 86400
  statistic           = "Minimum"
  threshold           = local.nodes_threshold
  alarm_description   = "This alarm indicates that at least one node in your cluster has been unreachable for one day"
  alarm_actions       = var.alarm_options.alarm_actions
  ok_actions          = var.alarm_options.ok_actions
  treat_missing_data  = "ignore"

  dimensions = {
    ClientId   = data.aws_caller_identity.this.account_id
    DomainName = aws_elasticsearch_domain.this.domain_name
  }

  tags = module.label.tags
}

resource aws_cloudwatch_metric_alarm automated_snapshot_failure {
  count               = var.alarm_options.enabled ? 1 : 0
  alarm_name          = join("-", [module.label.id, "es-AutomatedSnapshotFailure"])
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "AutomatedSnapshotFailure"
  namespace           = "AWS/ES"
  period              = 60
  statistic           = "Maximum"
  threshold           = 1
  alarm_description   = "An automated snapshot failed"
  alarm_actions       = var.alarm_options.alarm_actions
  ok_actions          = var.alarm_options.ok_actions
  treat_missing_data  = "ignore"

  dimensions = {
    ClientId   = data.aws_caller_identity.this.account_id
    DomainName = aws_elasticsearch_domain.this.domain_name
  }

  tags = module.label.tags
}

resource aws_cloudwatch_metric_alarm cpu_utilization {
  count               = var.alarm_options.enabled ? 1 : 0
  alarm_name          = join("-", [module.label.id, "es-CPUUtilization"])
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ES"
  period              = 900
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "100% CPU utilization isn't uncommon, but sustained high usage is problematic"
  alarm_actions       = var.alarm_options.alarm_actions
  ok_actions          = var.alarm_options.ok_actions
  treat_missing_data  = "ignore"

  dimensions = {
    ClientId   = data.aws_caller_identity.this.account_id
    DomainName = aws_elasticsearch_domain.this.domain_name
  }

  tags = module.label.tags
}

resource aws_cloudwatch_metric_alarm jvm_memory_pressure {
  count               = var.alarm_options.enabled ? 1 : 0
  alarm_name          = join("-", [module.label.id, "es-JVMMemoryPressure"])
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "JVMMemoryPressure"
  namespace           = "AWS/ES"
  period              = 300
  statistic           = "Maximum"
  threshold           = 80
  alarm_description   = "The cluster could encounter out of memory errors if usage increases. Consider scaling vertically."
  alarm_actions       = var.alarm_options.alarm_actions
  ok_actions          = var.alarm_options.ok_actions
  treat_missing_data  = "ignore"

  dimensions = {
    ClientId   = data.aws_caller_identity.this.account_id
    DomainName = aws_elasticsearch_domain.this.domain_name
  }

  tags = module.label.tags
}

