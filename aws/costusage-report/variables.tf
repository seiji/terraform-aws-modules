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

variable "time_unit" {
  type    = string
  default = "HOURLY"
}

variable "format" {
  type    = string
  default = "textORcsv"
}

variable "compression" {
  type    = string
  default = "GZIP"
}

variable "additional_schema_elements" {
  type    = list(string)
  default = ["RESOURCES"]
}

variable "s3_bucket" {
  type = string
}

variable "s3_prefix" {
  type = string
}

variable "s3_region" {
  type = string
}

variable "additional_artifacts" {
  type    = list(string)
  default = []
}

variable "report_versioning" {
  type    = string
  default = "CREATE_NEW_REPORT"
}
