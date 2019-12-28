terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  version = "~> 2.36"
  region  = local.region
}

locals {
  region    = "ap-northeast-1"
  namespace = "iam-policies"
  stage     = "staging"
}

module iam_policies {
  source = "../../iam-policy-custom"
}
