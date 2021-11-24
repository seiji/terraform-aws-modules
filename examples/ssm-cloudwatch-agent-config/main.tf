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
  vpc = {
    id                        = data.terraform_remote_state.vpc.outputs.id
    default_security_group_id = data.terraform_remote_state.vpc.outputs.default_security_group_id
    private_subnet_ids        = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    public_subnet_ids         = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  }
}

module "ami" {
  source = "../../ami-amzn2"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "terraform-aws-modules-tfstate"
    region = "ap-northeast-1"
    key    = "vpc-nati.examples"
  }
}

module "iam_role_ec2" {
  source    = "../../iam-role-ec2"
  namespace = local.namespace
  stage     = local.stage
}

module "lc" {
  source                      = "../../ec2-launch"
  namespace                   = local.namespace
  stage                       = local.stage
  ami_block_device_mappings   = module.ami.block_device_mappings
  associate_public_ip_address = false
  iam_instance_profile        = module.iam_role_ec2.instance_profile_id
  image_id                    = module.ami.id
  instance_type               = "t3.micro"
  key_name                    = "id_rsa"
  security_groups             = [local.vpc.default_security_group_id]
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

module "asg" {
  source               = "../../ec2-asg-lc"
  namespace            = local.namespace
  stage                = local.stage
  name                 = "cwa"
  max_size             = 1
  min_size             = 1
  health_check_type    = "EC2"
  launch_configuration = module.lc.configuration_name
  vpc_zone_identifier  = local.vpc.private_subnet_ids
}

data "template_file" "cloudwatch_agent_config" {
  template = file("./templates/cloudwatch-agent-config.json")
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

