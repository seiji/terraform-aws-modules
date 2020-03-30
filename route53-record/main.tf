resource aws_route53_record this {
  zone_id = var.zone_id
  name    = var.name
  type    = "A"

  dynamic alias {
    for_each = [for a in var.alias != null ? [var.alias] : [] : a]
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = false
    }
  }

  ttl     = var.ttl
  records = var.records
}
