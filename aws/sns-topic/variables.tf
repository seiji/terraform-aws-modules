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

variable "access_policy" {
  type = string
}
