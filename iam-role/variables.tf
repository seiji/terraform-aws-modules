variable name {
  type = string
}

variable principals {
  type = object(
    {
      type        = string
      identifiers = list(string)
    },
  )
}

variable policy_json_list {
  type        = list(string)
  description = "list of aws_iam_policy_document.json"
  default     = []
}

variable policy_arns {
  type        = list(string)
  description = "list of aws_iam_policy.arns"
  default     = []
}
