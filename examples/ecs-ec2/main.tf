terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "ecs-ec2.examples"
    encrypt        = true
    dynamodb_table = "terraform-aws-modules-tfstate-lock"
  }
}

provider "aws" {
  version = "~> 2.22"
  region  = local.region
}

locals {
  region    = "ap-northeast-1"
  namespace = "ecs-ec2"
  stage     = "staging"
}

module "vpc" {
  source          = "../../vpc"
  region          = local.region
  namespace       = local.namespace
  stage           = local.stage
  cidr_block      = "10.0.0.0/16"
  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  use_natgw       = false
}

module "iam_role_ecs" {
  source = "../../iam-role-ecs"
}

module "sg_alb_80" {
  source      = "../../vpc-sg"
  region      = local.region
  service     = local.namespace
  env         = local.stage
  name        = "alb_80"
  vpc_id      = module.vpc.vpc_id
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

module "sg_alb" {
  source      = "../../vpc-sg"
  region      = local.region
  service     = local.namespace
  env         = local.stage
  name        = "alb_443"
  vpc_id      = module.vpc.vpc_id
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

data "aws_acm_certificate" "this" {
  domain      = "*.seiji.me"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

module "ecs_ec2" {
  source = "../../ecs"

  namespace              = local.namespace
  stage                  = local.stage
  vpc_id                 = module.vpc.vpc_id
  subnet_private_id_list = module.vpc.private_subnet_id_list
  subnet_public_id_list  = module.vpc.public_subnet_id_list
  alb_security_id_list   = [module.vpc.default_security_group_id, module.sg_alb_80.id, module.sg_alb.id]
  image_id               = data.aws_ami.ecs_ami.id
  instance_type          = "t3.micro"
  ec2_security_id_list   = [module.vpc.default_security_group_id]
  ec2_iam_role           = "ecsInstanceRole"
  acm_arn                = data.aws_acm_certificate.this.arn
  container_port         = 80
  container_name         = "nginx"
  ecs_iam_role           = "ecsServiceRole"
  key_name               = "id_rsa"
}

