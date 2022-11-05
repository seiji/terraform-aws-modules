variable "service" {
  type = string
}

variable "env" {
  type = string
}

variable "attributes" {
  type     = list(string)
  nullable = false
  default  = []
}

variable "name" {
  type     = string
  nullable = false
  default  = ""
}

variable "add_tags" {
  type     = map(string)
  nullable = false
  default  = {}
}

variable "description" {
  type    = string
  default = "Managed by Terraform"
}

variable "access_log_settings" {
  type = object({
    destination_arn = string
    format          = string
  })
  default = null
}

variable "cors_configuration" {
  type = object({
    allow_credentials = bool
    allow_headers     = list(string)
    allow_methods     = list(string)
    allow_origins     = list(string)
    expose_headers    = list(string)
    max_age           = number
  })
  default = null
}

variable "disable_execute_api_endpoint" {
  type     = bool
  nullable = false
  default  = false
}

variable "domain_name" {
  type = object({
    domain_name = string
    domain_name_configuration = object({
      certificate_arn = string
      endpoint_type   = string
      security_policy = string
    })
  })
  default = null
}

variable "integrations" {
  type = map(object({
    connection_type        = string
    integration_method     = string
    integration_type       = string
    integration_uri        = string
    payload_format_version = string
  }))
  nullable = false
  default  = {}
}

variable "routes" {
  type = list(object({
    route_key       = string
    integration_key = string
  }))
  nullable = false
  default  = []
}

variable "vpc_link" {
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  default = null
}

variable "lambda_permission" {
  type = object({
    function_name = string
    source_path   = string
    statement_id  = string
  })
  default = null
}
