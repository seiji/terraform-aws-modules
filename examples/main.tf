terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    bucket         = "aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "main.examples"
    encrypt        = true
    dynamodb_table = "aws-modules-tfstate-lock"
  }
}

module "vpc" {
  source          = "../vpc"
  service         = "example"
  env             = "production"
  cidr_block      = "10.0.0.0/16"
  azs             = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_id_list" {
  value = module.vpc.private_subnet_id_list
}

output "public_subnet_id_list" {
  value = module.vpc.public_subnet_id_list
}

output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}
