variable name {
  type = string
}

variable identifier {
  type = string
}

variable policies {
  type        = list(string)
  description = "list of aws_iam_policy_document.json"
}
