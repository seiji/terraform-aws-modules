locals {
  label_order = ["service", "env", "attributes"]

  context = {
    service    = var.service
    env        = var.env
    attributes = join(var.delimiter, var.attributes)
  }

  labels      = [for l in local.label_order : local.context[l] if length(local.context[l]) > 0]
  id          = lower(format("%s%s", var.prefix, join(var.delimiter, local.labels)))
  name        = var.name == "" ? local.id : var.name
  tag_context = merge(local.context, { Name = local.name })
  tags        = merge({ for k, v in local.tag_context : k => v if length(v) > 0 }, var.add_tags)
  tags_list   = [for k, v in local.tags : { key = k, value = v }]
}
