module label {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  attributes = var.attributes
  name       = var.name
}

resource aws_s3_bucket this {
  bucket        = var.bucket_prefix == null ? module.label.id : null
  bucket_prefix = var.bucket_prefix != null ? var.bucket_prefix : null
  acl           = var.acl
  dynamic grant {
    for_each = var.grants
    content {
      id          = grant.value.id
      permissions = grant.value.permissions
      type        = grant.value.type
    }
  }
  dynamic lifecycle_rule {
    for_each = var.lifecycle_rule
    content {
      id                                     = lifecycle_rule.key
      prefix                                 = lifecycle_rule.value.prefix
      enabled                                = true
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
      dynamic noncurrent_version_transition {
        for_each = { for t in lifecycle_rule.value.noncurrent_version_transitions : t.storage_class => t }
        content {
          days          = noncurrent_version_transition.value.days
          storage_class = noncurrent_version_transition.value.storage_class
        }
      }
    }
  }
  dynamic server_side_encryption_configuration {
    for_each = [for v in var.server_side_encryption.enabled ? [var.server_side_encryption] : [] : v]
    content {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = server_side_encryption_configuration.value.kms_master_key_id
          sse_algorithm     = server_side_encryption_configuration.value.sse_algorithm
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
  force_destroy = var.force_destroy
  tags          = module.label.tags
}

resource aws_s3_bucket_public_access_block this {
  count                   = var.access_block_enabled ? 1 : 0
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on = [
    aws_s3_bucket.this,
    aws_s3_bucket_policy.this,
  ]
}

resource aws_s3_bucket_policy this {
  count  = var.bucket_policy == null ? 0 : 1
  bucket = aws_s3_bucket.this.id
  policy = var.bucket_policy
  depends_on = [
    aws_s3_bucket.this,
  ]
}
