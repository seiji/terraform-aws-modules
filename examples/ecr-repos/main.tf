terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = ">= 2.50"
  region  = "ap-northeast-1"
}


locals {
  namespace = "ecr-repos"
  stage     = "staging"
}

module ecr_repos {
  source    = "../../ecr"
  namespace = local.namespace
  stage     = local.stage
  repositories = [
    {
      name                  = "one"
      lifecycle_policy_json = null
    },
    {
      name                  = "two"
      lifecycle_policy_json = null
    },
  ]
}

