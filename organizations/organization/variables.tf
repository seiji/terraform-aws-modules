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
