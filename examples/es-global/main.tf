terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  version = "~> 2.44"
  region  = "ap-northeast-1"
}

locals {
  namespace = "es-vpc"
  stage     = "staging"
}

module es {
  source                = "../../es"
  namespace             = local.namespace
  stage                 = local.stage
  elasticsearch_version = "7.4"
  cluster_config = {
    instance_type            = "t2.small.elasticsearch"
    instance_count           = 1
    dedicated_master_enabled = false
    availability_zone_count  = 1
  }
  allowed_ips = ["118.243.74.112/32"]
}