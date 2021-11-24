variable "service" {
  type = string
}

variable "env" {
  type = string
}

variable "attributes" {
  type    = list(string)
  default = []
}

variable "name" {
  type    = string
  default = ""
}

variable "add_tags" {
  type    = map(string)
  default = {}
}

variable "description" {
  type    = string
  default = "Managed by Terraform"
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
  type    = bool
  default = false
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
  type = list(object({
    connection_id          = string
    connection_type        = string
    credentials_arn        = string
    integration_method     = string
    integration_type       = string
    integration_subtype    = string
    integration_uri        = string
    payload_format_version = string
    request_parameters     = map(string)
  }))
  default = []
}

variable "routes" {
  type = list(object({
    route_key  = string
    target_key = string
  }))
  default = []
}
