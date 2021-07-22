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

variable "domain" {
  type    = string
  default = "S3"
}

variable "endpoint_details" {
  type = object({
    subnet_ids = list(string)
    vpc_id     = string
    security_group_ids = list(string)
  })
  default = null
}

variable "users" {
  type = list(object({
    name = string
    role      = string
      entry  = string
      target = string
      posix_profile = object({
        gid            = number
        secondary_gids = list(string)
        uid            = number
      })
  }))
  default = []
}

