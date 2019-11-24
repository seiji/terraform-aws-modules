locals {
  time_period_start = "2019-01-01_00:00"
  time_unit         = "MONTHLY"

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

resource "aws_budgets_budget" "monthly_utilization" {
  name              = "savings-plans-monthly-utilization"
  budget_type       = "SAVINGS_PLANS_UTILIZATION"
  limit_amount      = "100.0"
  limit_unit        = "PERCENTAGE"
  time_period_start = local.time_period_start
  time_unit         = local.time_unit

  cost_types {
    include_credit             = false
    include_discount           = false
    include_other_subscription = false
    include_recurring          = false
    include_refund             = false
    include_subscription       = true
    include_support            = false
    include_tax                = false
    include_upfront            = false
    use_amortized              = false
    use_blended                = false
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

resource "aws_budgets_budget" "monthly_coverage" {
  name              = "savings-plans-monthly-coverage"
  budget_type       = "SAVINGS_PLANS_COVERAGE"
  limit_amount      = "100.0"
  limit_unit        = "PERCENTAGE"
  time_period_start = local.time_period_start
  time_unit         = local.time_unit

  cost_types {
    include_credit             = false
    include_discount           = false
    include_other_subscription = false
    include_recurring          = false
    include_refund             = false
    include_subscription       = true
    include_support            = false
    include_tax                = false
    include_upfront            = false
    use_amortized              = false
    use_blended                = false
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

