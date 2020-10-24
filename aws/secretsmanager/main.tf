module label {
  source     = "../../label"
  service    = var.service
  env        = var.env
  name       = var.name
  attributes = var.attributes
  add_tags   = var.add_tags
  delimiter  = "/"
}

resource aws_secretsmanager_secret this {
  name                    = module.label.id
  description             = var.description
  kms_key_id              = var.kms_key_id
  recovery_window_in_days = var.recovery_window_in_days
  tags                    = module.label.tags
}
