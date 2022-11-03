module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
  delimiter  = "."
}

resource "aws_route53_zone" "this" {
  name          = module.label.id
  force_destroy = var.force_destroy
  tags          = module.label.tags
}

resource "aws_route53_record" "ns" {
  allow_overwrite = true
  zone_id         = aws_route53_zone.this.zone_id
  name            = module.label.id
  type            = "NS"
  ttl             = "172800"
  records         = [for s in aws_route53_zone.this.name_servers : "${s}."]
  depends_on      = [aws_route53_zone.this]
}
