module "label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  stage     = var.stage
}

resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = var.name
  description = "discovery managed zone"
  vpc         = var.vpc_id
}

