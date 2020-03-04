variable namespace {
  type = string
}

variable stage {
  type = string
}

variable repositories {
  type = list(object({
    name                  = string
    lifecycle_policy_json = string
  }))
}

