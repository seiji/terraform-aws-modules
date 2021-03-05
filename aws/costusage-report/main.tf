module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  name       = var.name
  attributes = var.attributes
  add_tags   = var.add_tags
}

resource "aws_cur_report_definition" "this" {
  report_name                = module.label.id
  time_unit                  = var.time_unit
  format                     = var.format
  compression                = var.compression
  additional_schema_elements = var.additional_schema_elements
  s3_bucket                  = var.s3_bucket
  s3_prefix                  = var.s3_prefix
  s3_region                  = var.s3_region
  additional_artifacts       = var.additional_artifacts
  report_versioning          = var.report_versioning
}
