module "label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  stage     = var.stage
}

resource "aws_athena_workgroup" "primary" {
  name = "primary"

  configuration {
    bytes_scanned_cutoff_per_query     = var.bytes_scanned_cutoff_per_query
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = false

    result_configuration {
      output_location = "s3://${var.result.output_bucket}/${var.result.output_prefix}/"
    }
  }
}
