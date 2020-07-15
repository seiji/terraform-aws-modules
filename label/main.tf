locals {
  label_order = ["namespace", "stage", "attributes"]

  context = {
    namespace  = var.namespace
    stage      = var.stage
    attributes = join(var.delimiter, var.attributes)
  }

  labels      = [for l in local.label_order : local.context[l] if length(local.context[l]) > 0]
  id          = lower(format("%s%s", var.prefix, join(var.delimiter, local.labels)))
  name        = var.name == "" ? local.id : var.name
  tag_context = merge(local.context, { name = local.name })

  tag_title = merge({ for l in keys(local.tag_context) : title(l) => local.tag_context[l] if length(local.tag_context[l]) > 0 }, var.add_tags)

  tags = merge(local.tag_title, var.add_tags)
  tags_list = [
    for key in keys(local.tag_title) : merge({
      key   = key
      value = local.tags[key]
    }, var.add_tags)
  ]
}
