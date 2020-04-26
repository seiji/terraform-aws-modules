module iam_account {
  source = "../../iam/account"
  password_policy = {
    hard_expiry               = false
    max_password_age          = null
    minimum_password_length   = 32
    password_reuse_prevention = 24
  }
}
