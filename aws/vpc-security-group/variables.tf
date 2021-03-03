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

variable "vpc_id" {
  type = string
}

variable "rules" {
  type = list(object({
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = list(string)
    source_security_group_id = string
    self                     = bool
  }))
}
