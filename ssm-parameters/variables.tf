variable "namespace" {
  type = string
}

variable "stage" {
  type = string
}

variable "parameters" {
  type = map(object({
    type  = string
    value = string
  }))
}
