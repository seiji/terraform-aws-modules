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

variable "domain_name" {
  type = string
}

variable "subject_alternative_names" {
  type    = set(string)
  default = null
}

variable "validate" {
  type    = bool
  default = false
}

variable "zone_id" {
  type    = string
  default = null
}

