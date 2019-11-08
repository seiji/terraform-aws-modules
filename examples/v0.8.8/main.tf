terraform {
  required_version = "~> 0.9.0"

  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "v000900/development/terraform.tfstate"
    dynamodb_table = "terraform-aws-modules-tfstate-lock"
  }
}

# lock_table = "terraform-aws-modules-tfstate-lock"
#
#
module "vpc" {
  source          = "../../vpc-legacy"
  region          = "ap-northeast-1"
  namespace       = "v000808"
  stage           = "development"
  cidr_block      = "10.1.0.0/16"
  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24"]
}

