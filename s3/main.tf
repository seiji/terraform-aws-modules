module label {
  source    = "../label"
  namespace = var.namespace
  stage     = var.stage
}

resource aws_s3_bucket this {
  bucket = module.label.id
  acl    = "private"
  lifecycle_rule {
    enabled = true
    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }

    transition {
      days          = 100
      storage_class = "GLACIER"
    }
  }
  force_destroy = true
  tags          = module.label.tags
}

