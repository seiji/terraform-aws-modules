variable namespace {
  type = string
}

variable stage {
  type = string
}

variable runtime {
  type    = string
  default = "python3.6"
}

variable filename {
  type = string
}

variable handler {
  type = string
}

variable source_code_hash {
  type = string
}

variable layers {
  type = list(string)
}

variable role_policy {
  type = object({
    policy_jsons = list(string)
    policy_arns  = list(string)
  })
}

variable vpc_config {
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
}

variable environment {
  type    = map(string)
  default = null
}
