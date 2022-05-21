module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  name       = var.name
  attributes = var.attributes
}

resource "aws_ssm_document" "this" {
  name          = module.label.id
  content       = var.content
  document_type = var.document_type
  version_name  = var.version_name
  tags          = module.label.tags
  dynamic "attachments_source" {
    for_each = var.attachments_source != null ? [var.attachments_source] : []
    content {
      key    = attachments_source.value.key
      values = attachments_source.value.values
    }
  }
}
