variable "service" {
  type = string
}

variable "env" {
  type = string
}

variable "attributes" {
  type    = list(string)
  default = []
}

variable "name" {
  type    = string
  default = ""
}

variable "add_tags" {
  type    = map(string)
  default = {}
}

variable "role_arn" {
  type = string
}

variable "artifact_store" {
  type = list(object({
    location       = string
    type           = string
    encryption_key = string
    region         = string
  }))
}

variable "stage" {
  type = list(object({
    name = string
    action = object({
      category         = string
      configuration    = map(string)
      input_artifacts  = list(string)
      name             = string
      namespace        = string
      output_artifacts = list(string)
      owner            = string
      provider         = string
      region           = string
      role_arn         = string
      run_order        = string
      version          = string
    })
  }))
}
