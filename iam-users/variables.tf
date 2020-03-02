variable users {
  type = list(object({
    name   = string
    groups = list(string)
  }))
}
