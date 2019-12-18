terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  version = "~> 2.40"
  region  = "ap-northeast-1"
}

data terraform_remote_state vpc {
  backend = "s3"

  config = {
    bucket = "terraform-aws-modules-tfstate"
    region = "ap-northeast-1"
    key    = "vpc-nati.examples"
  }
}

locals {
  namespace = "ecs-ec2"
  stage     = "staging"
  vpc = {
    id                        = data.terraform_remote_state.vpc.outputs.id
    default_security_group_id = data.terraform_remote_state.vpc.outputs.default_security_group_id
    private_subnet_ids        = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    public_subnet_ids         = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  }
}

module iam_role_ecs {
  source = "../../iam-role-ecs"
}

module ami {
  source = "git::https://github.com/seiji/terraform-aws-ecs-ami.git?ref=master"
}

module iam_role_ec2 {
  source    = "../../iam-role-ec2"
  namespace = local.namespace
  stage     = local.stage
}

module launch {
  source                      = "../../ec2-launch"
  namespace                   = local.namespace
  stage                       = local.stage
  ami_block_device_mappings   = module.ami.block_device_mappings
  associate_public_ip_address = false
  iam_instance_profile        = module.iam_instance_profile.id
  image_id                    = module.ami.id
  image_name                  = "amzn2-ecs"
  key_name                    = "id_rsa"
  security_groups             = [local.vpc.default_security_group_id]
  userdata_part_cloud_config  = <<EOF
#cloud-config
repo_update: true
repo_upgrade: none
timezone: Asia/Tokyo
runcmd:
  - amazon-linux-extras install -y nginx1
  - systemctl enable nginx
  - systemctl start nginx
EOF
}

module "sg_https" {
  source      = "../../vpc-sg-https"
  namespace   = local.namespace
  stage       = local.stage
  vpc_id      = local.vpc.id
  cidr_blocks = ["0.0.0.0/0"]
}

# data "aws_acm_certificate" "this" {
#   domain      = "*.seiji.me"
#   types       = ["AMAZON_ISSUED"]
#   most_recent = true
# }
#

# module "ecs_ec2" {
#   source = "../../ecs-ec2"
#
#   namespace              = local.namespace
#   stage                  = local.stage
#   vpc_id                 = local.vpc.id
#   subnet_private_id_list = local.vpc.private_subnet_ids
#   subnet_public_id_list  = local.vpc.public_subnet_ids
#   alb_security_id_list   = [local.vpc.default_security_group_id, module.sg_https.id]
#   image_id               = module.ami.image_id
#   instance_type          = "t3.micro"
#   ec2_security_id_list   = [local.vpc.default_security_group_id]
#   ec2_iam_role           = "ecsInstanceRole"
#   acm_arn                = data.aws_acm_certificate.this.arn
#   container_port         = 80
#   container_name         = "nginx"
#   ecs_iam_role           = "ecsServiceRole"
#   key_name               = "id_rsa"
# }

