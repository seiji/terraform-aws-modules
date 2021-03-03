variable "service" {
  type = string
}

variable "env" {
  type = string
}

variable "name" {
  type    = string
  default = ""
}

variable "attributes" {
  type    = list(string)
  default = []
}

variable "retention_in_days" {
  default = 0
}

variable "metric_filters" {
  type = map(object({
    pattern = string
    metric_transformation = object({
      namespace = string
      value     = string
    })
  }))
  default = {}
}

variable "subscription_filter" {
  type = object({
    name            = string
    destination_arn = string
    distribution    = string
    filter_pattern  = string
    role_arn        = string
  })
  default = null
}
