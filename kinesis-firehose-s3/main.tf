module label {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  stage     = var.stage
}

resource aws_kinesis_firehose_delivery_stream this {
  name        = module.label.id
  destination = "s3"

  s3_configuration {
    role_arn        = module.iam_role_firehose.arn
    bucket_arn      = var.bucket_arn
    buffer_size     = 5
    buffer_interval = 60
    prefix          = module.label.id
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = var.log_group_name
      log_stream_name = "*"
    }
  }
}

data aws_iam_policy_document bucket {
  statement {
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]

    resources = [
      var.bucket_arn,
      "${var.bucket_arn}/*",
    ]
  }
}

data aws_iam_policy_document glue {
  statement {
    effect    = "Allow"
    actions   = ["glue:GetTableVersions"]
    resources = ["*"]
  }
}

data aws_iam_policy_document logs {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
}

module iam_role_firehose {
  source = "../iam-role"
  name   = "${module.label.id}-firehose"
  principals = {
    type        = "Service"
    identifiers = ["firehose.amazonaws.com"]
  }
  policy_json_list = [
    data.aws_iam_policy_document.bucket.json,
    data.aws_iam_policy_document.glue.json,
    data.aws_iam_policy_document.logs.json,
  ]
}

