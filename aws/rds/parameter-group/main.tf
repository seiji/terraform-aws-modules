module "label" {
  source     = "../../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

resource "aws_db_parameter_group" "this" {
  name        = module.label.id
  family      = var.family
  description = var.description
  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
  tags = module.label.tags
}
