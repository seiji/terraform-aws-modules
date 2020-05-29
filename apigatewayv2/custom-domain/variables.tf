variable namespace {
  type = string
}

variable stage {
  type = string
}

variable attributes {
  default = []
}

variable domain_name {
  type = string
}

variable domain_name_configuration {
  type = object({
    certificate_arn = string
    endpoint_type   = string
    security_policy = string
  })
}

variable api_mapping {
  type = list(object({
    api_id          = string
    stage           = string
    api_mapping_key = string
  }))
}
