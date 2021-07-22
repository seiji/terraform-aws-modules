variable "service" {
  type = string
}

variable "env" {
  type = string
}

variable "name" {
  type    = string
  default = ""
}

variable "attributes" {
  type    = list(string)
  default = []
}

variable "add_tags" {
  type    = map(string)
  default = {}
}

variable "rules" {
  type = list(object({
    completion_window        = number
    enable_continuous_backup = bool
    recovery_point_tags      = map(string)
    rule_name                = string
    schedule                 = string
    start_window             = number
    target_vault_name        = string
  }))
}
