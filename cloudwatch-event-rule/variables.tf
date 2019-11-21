variable "target_sns_topic_arn" {
  type = string
}

variable "enable_health" {
  default = false
}

variable "enable_ssm" {
  default = false
}

variable "enable_guard_duty" {
  default = false
}
