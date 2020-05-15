terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    key            = "vpc-nati.examples"
    dynamodb_table = "terraform-aws-modules-tfstate-lock"
  }
}

provider aws {
  version = ">= 2.62"
  region  = "ap-northeast-1"
}

locals {
  namespace = "vpc-nati"
  stage     = "staging"
}

module vpc {
  source          = "../../vpc-nati"
  namespace       = local.namespace
  stage           = local.stage
  cidr_block      = "10.0.0.0/16"
  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}

# module cloud_map {
#   source    = "../../service-discovery"
#   namespace = local.namespace
#   stage     = local.stage
#   vpc_id    = module.vpc.id
#   name      = "${local.stage}.local"
# }
