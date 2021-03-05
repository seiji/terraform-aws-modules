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

variable "instance_type" {
  type    = string
  default = "t3.nano"
}

variable "security_group_ids" {
  type = list(string)
}

variable "spot_price" {
  type    = string
  default = "0.002"
}

variable "subnet_id" {
  type = string
}
