terraform {
  required_version = "~> 0.12.0"
}

provider aws {
  version = "~> 2.43"
  region  = "ap-northeast-1"
}

locals {
  namespace = "vpc-natgw"
  stage     = "staging"
}

module vpc {
  source          = "../../vpc-natgw"
  namespace       = local.namespace
  stage           = local.stage
  cidr_block      = "10.0.0.0/16"
  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}
