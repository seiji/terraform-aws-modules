variable "limit_amount" {
  default = "10.0"
}

variable "limit_amount_ec2" {
  default = "5.0"
}

variable "limit_amount_lambda" {
  default = "5.0"
}

variable "limit_amount_s3" {
  default = "5.0"
}

variable "limit_amount_cloudwatch" {
  default = "5.0"
}

variable "subscriber_sns_topic_arns" {
  default = []
}
