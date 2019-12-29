variable groups {
  type = map(object({
    path     = string
    policies = list(string)
  }))
}

