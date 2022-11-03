module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

resource "aws_efs_file_system" "this" {
  creation_token = module.label.id
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  encrypted = true
  tags      = module.label.tags
}

resource "aws_efs_mount_target" "this" {
  for_each        = var.mount_targets
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value.subnet_id
  security_groups = each.value.security_groups
}
