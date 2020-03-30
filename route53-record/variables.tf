variable zone_id {
  type = string
}

variable name {
  type = string
}

variable alias {
  type = object({
    name    = string
    zone_id = string
  })
  default = null
}

variable ttl {
  type    = number
  default = 300
}

variable records {
  type    = list(string)
  default = null
}
