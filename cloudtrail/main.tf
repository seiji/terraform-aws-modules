module label {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  attributes = var.attributes
}

data aws_caller_identity this {}

resource aws_s3_bucket this {
  bucket        = var.bucket_name
  force_destroy = true

  tags = module.label.tags
}

resource aws_s3_bucket_policy this {
  bucket = aws_s3_bucket.this.id

  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AWSCloudTrailAclCheck",
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudtrail.amazonaws.com"
        },
        "Action": "s3:GetBucketAcl",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.this.id}"
      },
      {
        "Sid": "AWSCloudTrailWrite",
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudtrail.amazonaws.com"
        },
        "Action": "s3:PutObject",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.this.id}/AWSLogs/*",
        "Condition": {
          "StringEquals": {
            "s3:x-amz-acl": "bucket-owner-full-control"
          }
        }
      }
    ]
  }
POLICY

  depends_on = [aws_s3_bucket.this]
}

resource aws_cloudtrail this {
  name                          = module.label.id
  cloud_watch_logs_group_arn    = var.cloudwatch_log_group_arn
  cloud_watch_logs_role_arn     = var.cloudwatch_logs_role_arn
  enable_log_file_validation    = true
  enable_logging                = true
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = var.is_organization_trail
  s3_bucket_name                = aws_s3_bucket.this.id

  event_selector {
    include_management_events = true
    read_write_type           = "All"

    data_resource {
      type   = "AWS::S3::Object"
      values = var.logging_s3_bucket_arns
    }
    data_resource {
      type   = "AWS::Lambda::Function"
      values = var.logging_lambda_function_arns
    }
  }
  depends_on = [aws_s3_bucket.this]
  tags       = module.label.tags
}

