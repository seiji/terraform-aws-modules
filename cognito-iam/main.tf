resource "aws_cognito_user_pool" "this" {
  name = var.name
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = var.user_pool_domain
  user_pool_id = aws_cognito_user_pool.this.id

  depends_on = [
    aws_cognito_user_pool.this,
  ]
}

resource "aws_cognito_identity_pool" "this" {
  identity_pool_name               = var.name
  allow_unauthenticated_identities = false
}

resource "aws_cognito_identity_pool_roles_attachment" "unauth" {
  identity_pool_id = aws_cognito_identity_pool.this.id

  roles = {
    "authenticated"   = aws_iam_role.auth.arn
    "unauthenticated" = aws_iam_role.unauth.arn
  }

  depends_on = [
    aws_cognito_identity_pool.this,
    aws_iam_role.auth,
    aws_iam_role.unauth,
  ]
}

resource "aws_iam_role" "unauth" {
  name               = "Cognito_${var.name}Unauth_Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role" "auth" {
  name               = "Cognito_${var.name}Auth_Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "unauth" {
  name   = "${var.name}-unauth"
  role   = aws_iam_role.unauth.id
  policy = data.aws_iam_policy_document.unauth.json

  depends_on = [
    aws_iam_role.unauth,
  ]
}

resource "aws_iam_role_policy" "auth" {
  name   = "${var.name}-auth"
  role   = aws_iam_role.auth.id
  policy = data.aws_iam_policy_document.auth.json

  depends_on = [
    aws_iam_role.auth,
  ]
}
