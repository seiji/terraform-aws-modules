terraform {
  required_version = "~> 0.12.0"
}

provider aws {
  version = ">= 2.55"
  region  = "ap-northeast-1"
}

locals {
  namespace = "es-vpc"
  stage     = "staging"
}

data "aws_organizations_organization" "main" {}

data "null_data_source" "main" {
  count = length(data.aws_organizations_organization.main.accounts)
  inputs = {
    emails = data.aws_organizations_organization.main.accounts[count.index]["email"]
  }
}

output "accounts" {
  value = matchkeys(data.aws_organizations_organization.main.accounts, data.null_data_source.main.*.outputs.emails, list("toyama.seiji+awslog@gmai.com"))
}

# module sns_es {
#   source     = "../../sns"
#   namespace  = local.namespace
#   stage      = local.stage
#   attributes = ["es"]
# }
#
# module es {
#   source                = "../../es"
#   namespace             = local.namespace
#   stage                 = local.stage
#   elasticsearch_version = "7.4"
#   cluster_config = {
#     instance_type            = "t2.small.elasticsearch"
#     instance_count           = 1
#     dedicated_master_enabled = false
#     availability_zone_count  = 1
#   }
#   allowed_ips = ["118.243.74.112/32"]
#   alarm_options = {
#     enabled       = true
#     alarm_actions = [module.sns_es.arn]
#     ok_actions    = [module.sns_es.arn]
#   }
# }
#
