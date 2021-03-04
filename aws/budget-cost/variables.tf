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

variable "add_tags" {
  type    = map(string)
  default = {}
}

variable "limit_amount" {
  type = string
}

variable "time_unit" {
  type    = string
  default = "MONTHLY"
}

variable "notifications" {
  type = list(object({
    comparison_operator        = string
    notification_type          = string
    subscriber_email_addresses = list(string)
    subscriber_sns_topic_arns  = list(string)
    threshold                  = number
    threshold_type             = string
  }))
  default = []
}
