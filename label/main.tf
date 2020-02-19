locals {
  label_order = ["namespace", "stage", "name", "attributes"]
  context = {
    name       = var.name
    namespace  = var.namespace
    stage      = var.stage
    attributes = var.attributes
  }

  delimiter = var.delimiter
  labels    = [for l in local.label_order : local.context[l] if length(local.context[l]) > 0]
  id        = lower(join(local.delimiter, local.labels))

  tag_context = merge(local.context, {
    name = local.context.name == "" ? local.id : local.context.name
  })
  _tags = { for l in keys(local.tag_context) : title(l) => local.tag_context[l] if length(local.tag_context[l]) > 0 }

  tags = merge(local._tags, var.tags)
}
