variable password_policy {
  type = object({
    hard_expiry               = bool
    max_password_age          = number
    minimum_password_length   = number
    password_reuse_prevention = number
  })
}
