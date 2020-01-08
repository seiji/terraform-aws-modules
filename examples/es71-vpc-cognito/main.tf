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

data terraform_remote_state cognito {
  backend = "s3"

  config = {
    bucket = "terraform-aws-modules-tfstate"
    region = "ap-northeast-1"
    key    = "cognito4iam.examples"
  }
}

locals {
  namespace = "es71-cognito"
  stage     = "staging"
  vpc = {
    id                        = data.terraform_remote_state.vpc.outputs.id
    default_security_group_id = data.terraform_remote_state.vpc.outputs.default_security_group_id
    private_subnet_ids        = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    public_subnet_ids         = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  }
  cognito = {
    user_pool     = data.terraform_remote_state.cognito.outputs.user_pool
    identity_pool = data.terraform_remote_state.cognito.outputs.identity_pool
  }
}

module iam_role_es_cognito {
  source = "../../iam-role-es-cognito"
  name   = "ESCognitoAccess"
}

module es {
  source                = "../../es-vpc"
  namespace             = local.namespace
  stage                 = local.stage
  elasticsearch_version = "7.1"
  subnet_ids            = local.vpc.private_subnet_ids
  security_group_ids    = [local.vpc.default_security_group_id]
  instance_type         = "t2.small.elasticsearch"
  instance_count        = 2
  cognito = {
    enabled          = true
    user_pool_id     = local.cognito.user_pool.id
    identity_pool_id = local.cognito.identity_pool.id
    role_arn         = module.iam_role_es_cognito.role.arn
  }
}

