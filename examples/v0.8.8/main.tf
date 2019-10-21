module "vpc" {
  source          = "../../vpc-legacy"
  region          = "ap-northeast-1"
  namespace       = "v000808"
  stage           = "development"
  cidr_block      = "10.0.0.0/16"
  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}
