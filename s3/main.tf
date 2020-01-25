module label {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
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

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.this.id}",
      "arn:aws:s3:::${aws_s3_bucket.this.id}/*",
    ]
  }
}
