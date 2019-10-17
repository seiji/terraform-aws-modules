terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "coreos.examples"
    encrypt        = true
    dynamodb_table = "terraform-aws-modules-tfstate-lock"
  }
}

provider "aws" {
  version = "~> 2.22"
  region  = local.region
}

locals {
  region  = "ap-northeast-1"
  service = "coreos"
  env     = "production"
}

module "vpc" {
  source          = "../../vpc"
  region          = local.region
  service         = local.service
  env             = local.env
  cidr_block      = "10.0.0.0/16"
  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  use_natgw       = false
}

module "ec2_coreos" {
  source                      = "../../ec2-coreos"
  region                      = local.region
  service                     = local.service
  env                         = local.env
  name                        = "private"
  instance_type               = "t3.micro"
  vpc_id                      = module.vpc.vpc_id
  associate_public_ip_address = false
  subnet_private_id_list      = module.vpc.private_subnet_id_list
  subnet_public_id_list       = module.vpc.public_subnet_id_list
  alb_security_id_list        = []
  ec2_security_id_list        = [module.vpc.default_security_group_id]
  key_name                    = "id_rsa"
  use_cloudwatch_agent        = false
#   userdata_part_content = <<EOF
# #cloud-config
# repo_update: true
# repo_upgrade: none
# timezone: Asia/Tokyo
# locale: ja_JP.UTF-8
# runcmd:
#   - amazon-linux-extras install -y nginx1
#   - systemctl enable nginx
#   - systemctl start nginx
# EOF
}

