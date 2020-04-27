variable namespace {
  type = string
}

variable stage {
  type = string
}

variable name {
  type    = string
  default = ""
}

variable attributes {
  default = []
}

variable cloudwatch_log_group_name {
  type    = string
  default = null
}

variable cloudwatch_log_group_arn {
  type    = string
  default = null
}

variable cloudwatch_logs_role_arn {
  type    = string
  default = null
}

variable bucket_name {
  type = string
}

variable cloudwatch_metric_alarm {
  type = object({
    enabled       = bool
    alarm_actions = list(string)
  })
  default = {
    enabled       = false
    alarm_actions = []
  }
}

variable is_organization_trail {
  default = true
}

variable logging_s3_bucket_arns {
  type    = list(string)
  default = ["arn:aws:s3"]
}

variable logging_lambda_function_arns {
  type    = list(string)
  default = ["arn:aws:lambda"]
}
