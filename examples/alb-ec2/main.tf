terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "alb-ec2.examples"
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
  service = "alb-ec2"
  env     = "production"
}

data "aws_ami" "latest_amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
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

module "sg_alb_80" {
  source      = "../../vpc-sg"
  region      = local.region
  service     = local.service
  env         = local.env
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
  service     = local.service
  env         = local.env
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

module "ec2_private" {
  source                      = "../../ec2"
  region                      = local.region
  service                     = local.service
  env                         = local.env
  name                        = "private"
  image_id                    = data.aws_ami.latest_amazon_linux2.id
  instance_type               = "t3.micro"
  vpc_id                      = module.vpc.vpc_id
  associate_public_ip_address = false
  subnet_private_id_list      = module.vpc.private_subnet_id_list
  subnet_public_id_list       = module.vpc.public_subnet_id_list
  alb_security_id_list        = [module.vpc.default_security_group_id, module.sg_alb_80.id, module.sg_alb.id]
  ec2_security_id_list        = [module.vpc.default_security_group_id]
  key_name                    = "id_rsa"

  use_cloudwatch_agent  = false
  userdata_part_content = <<EOF
#cloud-config
repo_update: true
repo_upgrade: none
timezone: Asia/Tokyo
locale: ja_JP.UTF-8
runcmd:
  - amazon-linux-extras install -y nginx1
  - systemctl enable nginx
  - systemctl start nginx
EOF
  acm_arn               = data.aws_acm_certificate.this.arn
}


data "aws_route53_zone" "this" {
  name         = "seiji.me."
  private_zone = false
}

module "route53_record_alias" {
  source        = "../../route53-record-alias"
  name          = "example.seiji.me"
  zone_id       = data.aws_route53_zone.this.zone_id
  alias_name    = module.ec2_private.alb_dns_name
  alias_zone_id = module.ec2_private.alb_zone_id
}

