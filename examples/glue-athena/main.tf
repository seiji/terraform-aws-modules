terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  version = ">= 2.49"
  region  = "ap-northeast-1"
}

locals {
  namespace = "glue-athena"
  stage     = "staging"
}

module "athena" {
  source    = "../../athena"
  namespace = local.namespace
  stage     = local.stage
  result = {
    output_bucket = "data.seiji.me"
    output_prefix = "results"
  }
}
