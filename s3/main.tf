module label {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  attributes = var.attributes
}

resource aws_s3_bucket this {
  bucket = module.label.id
  acl    = "private"

  dynamic lifecycle_rule {
    for_each = [for r in var.lifecycle_rule.enabled ? [var.lifecycle_rule] : [] : r]
    content {
      enabled                                = lifecycle_rule.value.enabled
      abort_incomplete_multipart_upload_days = lifecycle_rule.value.abort_incomplete_multipart_upload_days
      dynamic expiration {
        for_each = [for e in lifecycle_rule.value.expiration != null ? [lifecycle_rule.value.expiration] : [] : e]
        content {
          days                         = expiration.value.days
          expired_object_delete_marker = expiration.value.expired_object_delete_marker
        }
      }
      dynamic noncurrent_version_expiration {
        for_each = [for e in lifecycle_rule.value.noncurrent_version_expiration != null ? [lifecycle_rule.value.noncurrent_version_expiration] : [] : e]
        content {
          days = noncurrent_version_expiration.value.days
        }
      }
      dynamic transition {
        for_each = { for t in lifecycle_rule.value.transitions : t.storage_class => t }
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }
    }
  }

  dynamic versioning {
    for_each = [for v in var.versioning.enabled ? [var.versioning] : [] : v]
    content {
      enabled    = versioning.value.enabled
      mfa_delete = versioning.value.mfa_delete
    }
  }
  force_destroy = true
  tags          = module.label.tags
}

