locals {
  budget_type       = "USAGE"
  limit_unit        = "GB"
  time_period_start = "2019-01-01_00:00"
  time_unit         = var.time_unit

  notifications = [
    {
      comparison_operator       = "GREATER_THAN"
      threshold                 = 100
      threshold_type            = "PERCENTAGE"
      notification_type         = "FORECASTED"
      subscriber_sns_topic_arns = var.subscriber_sns_topic_arns
    },
    {
      comparison_operator       = "GREATER_THAN"
      threshold                 = 50
      threshold_type            = "PERCENTAGE"
      notification_type         = "ACTUAL"
      subscriber_sns_topic_arns = var.subscriber_sns_topic_arns
    },
    {
      comparison_operator       = "GREATER_THAN"
      threshold                 = 75
      threshold_type            = "PERCENTAGE"
      notification_type         = "ACTUAL"
      subscriber_sns_topic_arns = var.subscriber_sns_topic_arns
    },
    {
      comparison_operator       = "GREATER_THAN"
      threshold                 = 100
      threshold_type            = "PERCENTAGE"
      notification_type         = "ACTUAL"
      subscriber_sns_topic_arns = var.subscriber_sns_topic_arns
    },
  ]
}

resource "aws_budgets_budget" "ec2_elb" {
  name              = "usage-ec2-elb-monthly"
  budget_type       = local.budget_type
  limit_amount      = var.limit_amount_ec2_elb
  limit_unit        = "Hrs"
  time_period_start = local.time_period_start
  time_unit         = local.time_unit

  cost_filters = {
    "UsageType:Amazon Elastic Load Balancing" = "APN1-LoadBalancerUsage"
  }

  dynamic "notification" {
    for_each = local.notifications
    content {
      comparison_operator       = notification.value.comparison_operator
      threshold                 = notification.value.threshold
      threshold_type            = notification.value.threshold_type
      notification_type         = notification.value.notification_type
      subscriber_sns_topic_arns = notification.value.subscriber_sns_topic_arns
    }
  }
}

resource "aws_budgets_budget" "s3" {
  name              = "usage-s3-monthly"
  budget_type       = local.budget_type
  limit_amount      = var.limit_amount_s3
  limit_unit        = "GB"
  time_period_start = local.time_period_start
  time_unit         = local.time_unit

  cost_filters = {
    UsageTypeGroup = "S3: Storage - Standard"
  }

  dynamic "notification" {
    for_each = local.notifications
    content {
      comparison_operator       = notification.value.comparison_operator
      threshold                 = notification.value.threshold
      threshold_type            = notification.value.threshold_type
      notification_type         = notification.value.notification_type
      subscriber_sns_topic_arns = notification.value.subscriber_sns_topic_arns
    }
  }
}
