variable service {
  type = string
}

variable env {
  type = string
}

variable attributes {
  type    = list(string)
  default = []
}

variable name {
  type    = string
  default = ""
}

variable add_tags {
  type    = map(string)
  default = {}
}

variable service_role {
  type = string
}

variable artifacts {
  type = list(object({
    type                   = string
    artifact_identifier    = string
    encryption_disabled    = bool
    override_artifact_name = bool
    location               = string
    name                   = string
    namespace_type         = string
    packaging              = string
    path                   = string
  }))
}

variable cache {
  type = object({
    type     = string
    location = string
    modes    = list(string)
  })
  default = null
}

variable environment {
  type = object({
    certificate  = string
    compute_type = string
    environment_variable = list(object({
      name  = string
      type  = string
      value = string
    }))
    image                       = string
    image_pull_credentials_type = string
    privileged_mode             = bool
    registry_credential = object({
      credential          = string
      credential_provider = string
    })
    type = string
  })
}

variable logs_config {
  type = object({
    cloudwatch_logs = object({
      status      = string
      group_name  = string
      stream_name = string
    })
    s3_logs = object({
      status              = string
      location            = string
      encryption_disabled = bool
    })
  })
  default = null
}

variable sources {
  type = list(object({
    type = string
    auth = object({
      type     = string
      resource = string
    })
    buildspec       = string
    git_clone_depth = number
    git_submodules_config = object({
      fetch_submodules = bool
    })
    insecure_ssl        = bool
    location            = string
    report_build_status = bool
  }))
}

variable webhook {
  type = object({
    filter_group = list(object({
      filter = list(object({
        type    = string
        pattern = string
      }))
    }))
  })
  default = null
}
