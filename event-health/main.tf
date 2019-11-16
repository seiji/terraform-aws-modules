resource "aws_cloudwatch_event_rule" "this" {
  name          = "health-all"
  event_pattern = <<PATTERN
{
  "source": [
    "aws.health"
  ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "this" {
  rule = aws_cloudwatch_event_rule.this.name
  arn  = var.target_sns_topic_arn
}
