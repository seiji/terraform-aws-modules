resource "aws_cloudwatch_event_rule" "health" {
  count         = var.enable_health ? 1 : 0
  name          = "health-all"
  event_pattern = <<PATTERN
{
  "source": [
    "aws.health"
  ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "health" {
  count = var.enable_health ? 1 : 0
  rule  = aws_cloudwatch_event_rule.health[count.index].name
  arn   = var.target_sns_topic_arn
}

resource "aws_cloudwatch_event_rule" "ssm" {
  count         = var.enable_ssm ? 1 : 0
  name          = "ssm-all"
  event_pattern = <<PATTERN
{
  "source": [
    "aws.ssm"
  ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "ssm" {
  count = var.enable_ssm ? 1 : 0
  rule  = aws_cloudwatch_event_rule.ssm[count.index].name
  arn   = var.target_sns_topic_arn
}
