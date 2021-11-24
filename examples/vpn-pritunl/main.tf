terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  version = ">= 2.50"
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
  namespace = "vpc-pritunl"
  stage     = "staging"
  vpc = {
    id                        = data.terraform_remote_state.vpc.outputs.id
    default_security_group_id = data.terraform_remote_state.vpc.outputs.default_security_group_id
    private_subnet_ids        = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    public_subnet_ids         = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  }
  cidr_blocks = ["0.0.0.0/0"]
}

data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = ["OL7.6-x86_64-HVM-2019-01-29"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["131827586825"]
}

module "iam_role_ec2" {
  source    = "../../iam-role-ec2"
  namespace = local.namespace
  stage     = local.stage
}

data "local_file" "cloud_init" {
  filename = "./templates/cloud-init.yml"
}

module "sg_pritunl" {
  source     = "../../vpc-sg"
  namespace  = local.namespace
  stage      = local.stage
  attributes = ["pritunl"]
  vpc_id     = local.vpc.id
  rules = [
    {
      from_port                = 10000
      to_port                  = 19999
      protocol                 = "udp"
      cidr_blocks              = local.cidr_blocks
      source_security_group_id = null
      self                     = null
    }
  ]
}

module "launch" {
  source                      = "../../ec2-launch"
  namespace                   = local.namespace
  stage                       = local.stage
  ami_block_device_mappings   = data.aws_ami.this.block_device_mappings
  associate_public_ip_address = true
  iam_instance_profile        = module.iam_role_ec2.instance_profile_id
  image_id                    = data.aws_ami.this.id
  image_name                  = "oracle"
  key_name                    = "id_rsa"
  security_groups             = [local.vpc.default_security_group_id, module.sg_pritunl.id]
  root_block_device_size      = 15
  userdata_part_cloud_config  = data.local_file.cloud_init.content
}

module "asg" {
  source                                   = "../../ec2-asg-lt"
  namespace                                = local.namespace
  stage                                    = local.stage
  name                                     = module.launch.template_name
  instance_types                           = ["t3a.micro", "t3.micro"]
  max_size                                 = 1
  min_size                                 = 1
  desired_capacity                         = 1
  health_check_type                        = "EC2"
  launch_template_id                       = module.launch.template_id
  vpc_zone_identifier                      = local.vpc.public_subnet_ids
  on_demand_base_capacity                  = 0
  on_demand_percentage_above_base_capacity = 0
}

