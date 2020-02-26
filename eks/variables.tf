variable namespace {
  type = string
}

variable stage {
  type = string
}

variable cluster_version {
  type = string
}

variable vpc_config {
  type = object({
    subnet_ids             = list(string)
    security_group_ids     = list(string)
    endpoint_public_access = bool
  })
}

