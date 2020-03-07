module label {
  source    = "../label"
  namespace = var.namespace
  stage     = var.stage
}

resource aws_organizations_account master {
  name  = "my_new_account"
  email = "john@doe.org"
}
