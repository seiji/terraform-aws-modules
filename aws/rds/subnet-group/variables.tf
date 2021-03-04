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

variable "description" {
  type    = string
  default = null
}

variable "subnet_ids" {
  type = list(string)
}
