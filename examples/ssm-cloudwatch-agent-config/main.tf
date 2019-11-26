terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "config.cloudwatchagent.examples"
    encrypt        = true
    dynamodb_table = "terraform-aws-modules-tfstate-lock"
  }
}

provider "aws" {
  version = "~> 2.39"
  region  = local.region
}

locals {
  region    = "ap-northeast-1"
  namespace = "cloudwatch-agent-config"
  stage     = "staging"
}

module ami {
  source = "../../ami-amazonlinux2"
}

module vpc {
  source          = "../../vpc"
  namespace       = local.namespace
  stage           = local.stage
  cidr_block      = "10.0.0.0/16"
  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  use_natgw       = false
}

module iam_instance_profile_ec2 {
  source    = "../../iam-instance-profile-ec2"
  namespace = local.namespace
  stage     = local.stage
}

module lc {
  source                      = "../../ec2-launch"
  namespace                   = local.namespace
  stage                       = local.stage
  name                        = "cwa"
  associate_public_ip_address = false
  iam_instance_profile        = module.iam_instance_profile_ec2.id
  image_id                    = module.ami.id
  instance_type               = "t3.micro"
  key_name                    = "id_rsa"
  security_groups             = [module.vpc.default_security_group_id]
  userdata_part_cloud_config  = <<EOF
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
}

module asg {
  source               = "../../ec2-auto-scaling-groups"
  namespace            = local.namespace
  stage                = local.stage
  name                 = "cwa"
  max_size             = 1
  min_size             = 1
  desired_capacity     = 1
  health_check_type    = "EC2"
  launch_configuration = module.lc.configuration_name
  vpc_zone_identifier  = module.vpc.private_subnet_ids
}

data "template_file" "cloudwatch_agent_config" {
  template = "${file("./templates/cloudwatch-agent-config.json")}"
}

module "ssm_parameters" {
  source = "../../ssm-parameters"

  namespace = local.namespace
  stage     = local.stage

  parameters = {
    "cloudwatch-agent-config" = {
      type  = "String",
      value = data.template_file.cloudwatch_agent_config.rendered,
    },
  }
}

module "ssm_document" {
  source = "../../ssm-document-cloudwatch-agent"

  namespace   = local.namespace
  stage       = local.stage
  name        = "${local.namespace}-${local.stage}-cloudwatch-manage"
  config_name = module.ssm_parameters.params["cloudwatch-agent-config"].name
}

