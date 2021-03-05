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

variable "mount_targets" {
  type = map(object({
    subnet_id       = string
    security_groups = list(string)
  }))
  default = {}
}

