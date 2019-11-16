locals {
  budget_type       = "COST"
  limit_unit        = "USD"
  time_period_start = "2019-01-01_00:00"
  time_unit         = "MONTHLY"

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

resource "aws_budgets_budget" "total" {
  name              = "cost-total-monthly"
  budget_type       = local.budget_type
  limit_amount      = var.limit_amount
  limit_unit        = local.limit_unit
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

resource "aws_budgets_budget" "ec2" {
  name              = "cost-ec2-monthly"
  budget_type       = local.budget_type
  limit_amount      = var.limit_amount_ec2
  limit_unit        = local.limit_unit
  time_period_start = local.time_period_start
  time_unit         = local.time_unit

  cost_filters = {
    Service = "Amazon Elastic Compute Cloud - Compute"
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

resource "aws_budgets_budget" "lambda" {
  name              = "cost-lambda-monthly"
  budget_type       = local.budget_type
  limit_amount      = var.limit_amount_lambda
  limit_unit        = local.limit_unit
  time_period_start = local.time_period_start
  time_unit         = local.time_unit

  cost_filters = {
    Service = "AWS Lambda"
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
  name              = "cost-s3-monthly"
  budget_type       = local.budget_type
  limit_amount      = var.limit_amount_s3
  limit_unit        = local.limit_unit
  time_period_start = local.time_period_start
  time_unit         = local.time_unit

  cost_filters = {
    Service = "Amazon Simple Storage Service"
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

resource "aws_budgets_budget" "cloudwatch" {
  name              = "cost-cloudwatch-monthly"
  budget_type       = local.budget_type
  limit_amount      = var.limit_amount_cloudwatch
  limit_unit        = local.limit_unit
  time_period_start = local.time_period_start
  time_unit         = local.time_unit

  cost_filters = {
    Service = "AmazonCloudWatch"
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
