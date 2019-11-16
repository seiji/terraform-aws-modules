locals {
  budget_type = "COST"
  limit_unit = "USD"
  time_period_start = "2019-01-01_00:00"
  time_unit = "MONTHLY"

  notifications = [
    {
      comparison_operator        = "GREATER_THAN"
      threshold                  = 100
      threshold_type             = "PERCENTAGE"
      notification_type          = "FORECASTED"
      subscriber_sns_topic_arns  = var.subscriber_sns_topic_arns
    }
  ]
}

resource "aws_budgets_budget" "total" {
  name              = "total-monthly"
  budget_type       = local.budget_type
  limit_amount      = var.limit_amount
  limit_unit        = local.limit_unit
  time_period_start = local.time_period_start
  time_unit         = local.time_unit

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_sns_topic_arns  = var.subscriber_sns_topic_arns
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 50
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_sns_topic_arns  = var.subscriber_sns_topic_arns
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 75
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_sns_topic_arns  = var.subscriber_sns_topic_arns
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_sns_topic_arns  = var.subscriber_sns_topic_arns
  }
}

resource "aws_budgets_budget" "ec2" {
  name              = "ec2-monthly"
  budget_type       = local.budget_type
  limit_amount      = var.limit_amount_ec2
  limit_unit        = local.limit_unit
  time_period_start = local.time_period_start
  time_unit         = local.time_unit

  cost_filters = {
    Service = "Amazon Elastic Compute Cloud - Compute"
  }

}

resource "aws_budgets_budget" "lambda" {
  name              = "lambda-monthly"
  budget_type       = local.budget_type
  limit_amount      = var.limit_amount_lambda
  limit_unit        = local.limit_unit
  time_period_start = local.time_period_start
  time_unit         = local.time_unit

  cost_filters = {
    Service = "AWS Lambda"
  }
}

resource "aws_budgets_budget" "s3" {
  name              = "s3-monthly"
  budget_type       = local.budget_type
  limit_amount      = var.limit_amount_s3
  limit_unit        = local.limit_unit
  time_period_start = local.time_period_start
  time_unit         = local.time_unit

  cost_filters = {
    Service = "Amazon Simple Storage Service"
  }
}

resource "aws_budgets_budget" "cloudwatch" {
  name              = "cloudwatch-monthly"
  budget_type       = local.budget_type
  limit_amount      = var.limit_amount_cloudwatch
  limit_unit        = local.limit_unit
  time_period_start = local.time_period_start
  time_unit         = local.time_unit

  cost_filters = {
    Service = "AmazonCloudWatch"
  }
}
