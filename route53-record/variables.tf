variable "zone_id" {
  type = string
}

variable "name" {
  type = string
}

variable "alias" {
  type = object({
    name    = string
    zone_id = string
  })
  default = null
}

variable "ttl" {
  type    = number
  default = null
}

variable "records" {
  type    = list(string)
  default = null
}
