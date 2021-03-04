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

variable "default" {
  type    = bool
  default = false
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "igress" {
  type = list(object({
    rule_number = number
    protocol    = string
    cidr_block  = string
    from_port   = number
    to_port     = number
  }))
  default = []
}

variable "egress" {
  type = list(object({
    rule_number = number
    protocol    = string
    cidr_block  = string
    from_port   = number
    to_port     = number
  }))
  default = []
}
