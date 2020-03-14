variable namespace {
  type = string
}

variable stage {
  type = string
}

variable layer {
  type = object({
    filename         = string
    source_code_hash = string
  })
}

variable function {
  type = object({
    filename         = string
    handler          = string
    source_code_hash = string
  })
}
