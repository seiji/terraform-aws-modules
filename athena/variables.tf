variable namespace {
  type = string
}

variable stage {
  type = string
}

variable bytes_scanned_cutoff_per_query {
  default = 10485760
}

variable result {
  type = object({
    output_bucket = string
    output_prefix = string
  })
}
