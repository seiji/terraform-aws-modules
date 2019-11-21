locals {
  event_pattern_health     = <<PATTERN
{
  "source": [
    "aws.health"
  ]
}
PATTERN
  event_pattern_ssm        = <<PATTERN
{
  "source": [
    "aws.ssm"
  ]
}
PATTERN
  event_pattern_guard_duty = <<PATTERN
{
  "source": [
    "aws.guardduty"
  ]
}
PATTERN
}

resource "aws_cloudwatch_event_rule" "health" {
  count         = var.enable_health ? 1 : 0
  name          = "health-all"
  event_pattern = local.event_pattern_health
}

resource "aws_cloudwatch_event_target" "health" {
  count = var.enable_health ? 1 : 0
  rule  = aws_cloudwatch_event_rule.health[count.index].name
  arn   = var.target_sns_topic_arn
}

resource "aws_cloudwatch_event_rule" "ssm" {
  count         = var.enable_ssm ? 1 : 0
  name          = "ssm-all"
  event_pattern = local.event_pattern_ssm
}

resource "aws_cloudwatch_event_target" "ssm" {
  count = var.enable_ssm ? 1 : 0
  rule  = aws_cloudwatch_event_rule.ssm[count.index].name
  arn   = var.target_sns_topic_arn
}

resource "aws_cloudwatch_event_rule" "guard_duty" {
  count         = var.enable_guard_duty ? 1 : 0
  name          = "guard-duty-all"
  event_pattern = local.event_pattern_guard_duty
}

resource "aws_cloudwatch_event_target" "guard_duty" {
  count = var.enable_guard_duty ? 1 : 0
  rule  = aws_cloudwatch_event_rule.guard_duty[count.index].name
  arn   = var.target_sns_topic_arn
}
