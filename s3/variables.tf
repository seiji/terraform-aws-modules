variable service {
  type = string
}

variable env {
  type = string
}

variable attributes {
  default = []
}

variable name {
  type    = string
  default = ""
}

variable bucket_prefix {
  type    = string
  default = null
}

variable acl {
  type    = string
  default = "private"
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
  type = map(object({
    prefix                                 = string
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
    noncurrent_version_transitions = list(object({
      days          = number
      storage_class = string
    }))
  }))
  default = {}
}

variable server_side_encryption {
  type = object({
    enabled           = bool
    sse_algorithm     = string
    kms_master_key_id = string
  })
  default = {
    enabled           = false
    sse_algorithm     = "AES256"
    kms_master_key_id = null
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

variable force_destroy {
  type    = bool
  default = false
}

variable bucket_policy {
  type    = string
  default = null
}

variable access_block_enabled {
  type    = bool
  default = true
}
