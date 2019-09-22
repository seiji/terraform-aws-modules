variable "region" {
  type    = "string"
  default = "ap-northeast-1"
}

variable "s3_bucket" {
  type = "string"
}

variable "dynamodb_table" {
  type = "string"
}
