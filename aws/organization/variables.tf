variable aws_service_access_principals {
  type = list(string)
}

variable enabled_policy_types {
  type = list(string)
}

variable feature_set {
  type    = string
  default = "ALL"
}

variable service_control_policies {
  type = map(object({
    content     = string
    description = string
  }))
  default = {}
}

variable root_units {
  type    = map(list(string))
  default = {}
}

variable accounts {
  type = map(object({
    email            = string
    parent_unit_name = string
  }))
  default = {}
}

