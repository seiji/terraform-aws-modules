module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  name       = var.name
  attributes = var.attributes
  add_tags   = var.add_tags
}

data "aws_backup_vault" "default" {
  name = "Default"
}

resource "aws_backup_plan" "this" {
  name = module.label.id

  dynamic rule {
    for_each = var.rules
    content {
      completion_window        = rule.value.completion_window
      enable_continuous_backup = rule.value.enable_continuous_backup
      recovery_point_tags      = rule.value.recovery_point_tags
      rule_name         = rule.value.rule_name
      schedule          = rule.value.schedule
      start_window             = rule.value.start_window
      target_vault_name = rule.value.target_vault_name
      copy_action {
        destination_vault_arn = data.aws_backup_vault.default.arn
      }
      lifecycle {
        cold_storage_after = 0
        delete_after       = 1
      }
    }
  }
}
