variable "namespace" {
  type = string
}

variable "stage" {
  type = string
}

variable "sns_topic_arn" {
  type = string
}

variable "db_instance_ids" {
  type = list(any)
}
