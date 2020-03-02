variable users {
  type = list(object({
    name   = string
    path   = string
    groups = list(string)
  }))
}
