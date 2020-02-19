locals {
  label_order = ["namespace", "stage", "name", "attributes"]
  delimiter   = var.delimiter
  context = {
    name       = var.name
    namespace  = var.namespace
    stage      = var.stage
    attributes = join(local.delimiter, var.attributes)
  }
  add_tags = var.add_tags

  labels = [for l in local.label_order : local.context[l] if length(local.context[l]) > 0]
  id     = lower(join(local.delimiter, local.labels))

  tag_context = merge(local.context, {
    name = local.context.name == "" ? local.id : local.context.name
  })
  _tags = { for l in keys(local.tag_context) : title(l) => local.tag_context[l] if length(local.tag_context[l]) > 0 }

  tags = merge(local._tags, local.add_tags)
  tags_list = [
    for key in keys(local._tags) : merge({
      key   = key
      value = local.tags[key]
    }, local.add_tags)
  ]
}
