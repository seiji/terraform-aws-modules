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

variable "description" {
  type    = string
  default = "Managed by Terraform"
}

variable "attachments_source" {
  type = object({
    key    = string
    values = list(string)
  })
  default = null
}

variable "content" {
  type = string
}

variable "document_type" {
  type    = string
  default = "Package"
}

variable "version_name" {
  type    = string
  default = null
}

