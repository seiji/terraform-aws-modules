module label {
  source     = "../../label"
  service    = var.service
  env        = var.env
  name       = var.name
  attributes = var.attributes
  add_tags   = var.add_tags
}

resource aws_sns_topic this {
  name         = module.label.id
  display_name = module.label.id
  tags         = module.label.tags
}

resource aws_sns_topic_policy this {
  arn    = aws_sns_topic.this.arn
  policy = var.access_policy
}
