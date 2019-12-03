variable namespace {
  type = string
}

variable stage {
  type = string
}

variable bucket_name {
  type = string
}

variable is_multi_region_trail {
  default = true
}

variable is_organization_trail {
  default = true
}

variable logging_s3_bucket_arns {
  default = ["arn:aws:s3"]
}

variable logging_lambda_function_arns {
  default = ["arn:aws:lambda"]
}
