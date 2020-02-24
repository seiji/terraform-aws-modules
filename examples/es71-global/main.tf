terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  version = "~> 2.40"
  region  = "ap-northeast-1"
}

data terraform_remote_state vpc {
  backend = "s3"

  config = {
    bucket = "terraform-aws-modules-tfstate"
    region = "ap-northeast-1"
    key    = "vpc-nati.examples"
  }
}

locals {
  namespace = "es71-vpc"
  stage     = "staging"
  vpc = {
    id                        = data.terraform_remote_state.vpc.outputs.id
    default_security_group_id = data.terraform_remote_state.vpc.outputs.default_security_group_id
    private_subnet_ids        = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    public_subnet_ids         = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  }
}

module es {
  source                = "../../es-vpc"
  namespace             = local.namespace
  stage                 = local.stage
  elasticsearch_version = "7.1"
  cluster_config = {
    instance_type            = "t2.small.elasticsearch"
    instance_count           = 1
    dedicated_master_enabled = false
    availability_zone_count  = 1
  }
  allowed_ips = ["124.155.111.68/32"]
}
