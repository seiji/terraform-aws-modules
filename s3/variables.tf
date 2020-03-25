variable namespace {
  type = string
}

variable stage {
  type = string
}

variable attributes {
  default = []
}

variable grants {
  type = list(object({
    id          = string
    permissions = list(string)
    type        = string
  }))
  default = []
}

variable lifecycle_rule {
  type = object({
    enabled                                = bool
    abort_incomplete_multipart_upload_days = number
    expiration = object({
      days                         = number
      expired_object_delete_marker = bool
    })
    noncurrent_version_expiration = object({
      days = number
    })
    transitions = list(object({
      days          = number
      storage_class = string
    }))
  })
  default = {
    enabled                                = true
    abort_incomplete_multipart_upload_days = null
    expiration                             = null
    noncurrent_version_expiration          = null
    transitions = [
      {
        days          = 0
        storage_class = "INTELLIGENT_TIERING"
      },
      {
        days          = 100
        storage_class = "GLACIER"
      },
    ]
  }
}

variable versioning {
  type = object({
    enabled    = bool
    mfa_delete = bool
  })
  default = {
    enabled    = false
    mfa_delete = false
  }
}
