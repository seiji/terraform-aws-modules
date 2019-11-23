locals {
  budget_type       = "SAVINGS_PLANS_UTILIZATION"
  time_period_start = "2019-01-01_00:00"
  time_unit         = var.time_unit

  notifications = [
    {
      comparison_operator       = "LESS_THAN"
      threshold                 = 100
      threshold_type            = "PERCENTAGE"
      notification_type         = "ACTUAL"
      subscriber_sns_topic_arns = var.subscriber_sns_topic_arns
    },
  ]
}

resource "aws_budgets_budget" "ec2_monthly_utilization" {
  name              = "savings-plans-ec2-monthly-utilization"
  budget_type       = local.budget_type
  limit_amount      = "100.0"
  limit_unit        = "PERCENTAGE"
  time_period_start = local.time_period_start
  time_unit         = local.time_unit

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

