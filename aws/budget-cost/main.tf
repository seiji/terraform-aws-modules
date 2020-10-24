module label {
  source     = "../../label"
  service    = var.service
  env        = var.env
  name       = var.name
  attributes = var.attributes
  add_tags   = var.add_tags
}

resource aws_budgets_budget this {
  budget_type       = "COST"
  limit_amount      = var.limit_amount
  limit_unit        = "USD"
  name              = module.label.id
  time_period_start = "2020-01-01_00:00"
  time_unit         = var.time_unit
  cost_types {
    include_credit             = false
    include_discount           = true
    include_other_subscription = true
    include_recurring          = true
    include_refund             = false
    include_subscription       = true
    include_support            = true
    include_tax                = true
    include_upfront            = true
    use_amortized              = false
    use_blended                = false
  }
  dynamic notification {
    for_each = var.notifications
    content {
      comparison_operator        = notification.value.comparison_operator
      notification_type          = notification.value.notification_type
      subscriber_email_addresses = notification.value.subscriber_sns_topic_arns
      subscriber_sns_topic_arns  = notification.value.subscriber_sns_topic_arns
      threshold                  = notification.value.threshold
      threshold_type             = notification.value.threshold_type
    }
  }
}
