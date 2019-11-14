terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    bucket         = "aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "main.examples"
    encrypt        = true
    dynamodb_table = "aws-modules-tfstate-lock"
  }
}

provider "aws" {
  version = "~> 2.22"
  region  = local.region
}

locals {
  region = "ap-northeast-1"
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}


data "aws_subnet_ids" "private" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Tier = "Private"
  }
}

module "vpc" {
  source          = "../vpc"
  region          = local.region
  service         = "example"
  env             = "production"
  cidr_block      = "10.0.0.0/16"
  azs             = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  use_natgw       = false

  use_endpoint_ssm          = false
  use_endpoint_ssm_messages = false
  use_endpoint_ec2          = false
  use_endpoint_ec2_messages = false
}

module "ec2_private" {
  source                      = "../ec2"
  region                      = local.region
  service                     = "example"
  env                         = "production"
  name                        = "private"
  instance_type               = "t2.nano"
  associate_public_ip_address = false
  subnet_id_list              = data.aws_subnet_ids.private.ids
  security_id_list            = [data.aws_security_group.default.id]
  key_name                    = "id_rsa"

  use_cloudwatch_agent        = false
}

