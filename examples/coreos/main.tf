terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = "~> 2.22"
  region  = "ap-northeast-1"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "terraform-aws-modules-tfstate"
    region = "ap-northeast-1"
    key    = "vpc-nati.examples"
  }
}

locals {
  namespace = "coreos"
  stage     = "staging"
  vpc = {
    id                        = data.terraform_remote_state.vpc.outputs.id
    default_security_group_id = data.terraform_remote_state.vpc.outputs.default_security_group_id
    private_subnet_ids        = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    public_subnet_ids         = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  }
}

module "sg_ssh" {
  source     = "../../vpc-sg"
  namespace  = local.namespace
  stage      = local.stage
  attributes = ["ssh"]
  vpc_id     = local.vpc.id
  rules = [{
    from_port                = 22
    to_port                  = 22
    protocol                 = "tcp"
    cidr_blocks              = ["0.0.0.0/0"]
    source_security_group_id = null
    self                     = null
  }]
}

module "ec2_coreos" {
  source                      = "../../ec2-coreos"
  namespace                   = local.namespace
  stage                       = local.stage
  attributes                  = ["private"]
  instance_type               = "t3.micro"
  vpc_id                      = local.vpc.id
  associate_public_ip_address = true
  subnet_private_id_list      = local.vpc.private_subnet_ids
  subnet_public_id_list       = local.vpc.public_subnet_ids
  alb_security_id_list        = []
  ec2_security_id_list        = [local.vpc.default_security_group_id, module.sg_ssh.id]
  key_name                    = "id_rsa"
  use_cloudwatch_agent        = true
}

