// chatbot does not support directly
resource "aws_db_event_subscription" "this" {
  name      = "rds-event-sub"
  sns_topic = var.sns_topic_arn

  source_type = "db-instance"
  source_ids  = var.db_instance_ids

  # event_categories = [
  #   "failover",
  #   "failure",
  #   "low storage",
  #   "maintenance",
  #   "notification",
  #   "recovery",
  # ]

  event_categories = [
    "availability",
    "deletion",
    "failover",
    "failure",
    "low storage",
    "maintenance",
    "notification",
    "read replica",
    "recovery",
    "restoration",
  ]
}
