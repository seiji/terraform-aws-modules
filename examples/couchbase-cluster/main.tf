terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    bucket         = "aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "couchbase-cluster.examples"
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

data "aws_subnet_ids" "public" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Tier = "Public"
  }
}

module "vpc" {
  source          = "../../vpc"
  region          = local.region
  service         = "example"
  env             = "production"
  cidr_block      = "10.0.0.0/16"
  azs             = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  use_natgw = false

  use_endpoint_ec2          = true
  use_endpoint_ec2_messages = true
  use_endpoint_logs         = false
  use_endpoint_monitoring   = true
  use_endpoint_ssm          = true
  use_endpoint_ssm_messages = true
}

module "ec2_private" {
  source                      = "../../ec2"
  region                      = local.region
  service                     = "example"
  env                         = "production"
  name                        = "private"
  image_id                    = "ami-045f38c93733dd48d"
  instance_type               = "t3.micro"
  vpc_id                      = module.vpc.vpc_id
  associate_public_ip_address = false
  subnet_private_id_list      = data.aws_subnet_ids.private.ids
  subnet_public_id_list       = data.aws_subnet_ids.public.ids
  security_id_list            = [data.aws_security_group.default.id]
  key_name                    = "id_rsa"

  use_cloudwatch_agent  = true
  userdata_part_content = <<EOF
#cloud-config
repo_update: true
repo_upgrade: none
timezone: Asia/Tokyo
locale: ja_JP.UTF-8
bootcmd:
  - |
    rm -f /etc/sysconfig/network-scripts/ifcfg-eth0
    for PATH_DHCLIENT_PID in /var/run/dhclient*; do
        export PATH_DHCLIENT_PID
        dhclient -r
        # Making sure it really truly stopped
        kill $(<PATH_DHCLIENT_PID) || true
        rm -f "$PATH_DHCLIENT_PID"
    done
    systemctl restart network
  - sysctl vm.swappiness=0
  - echo never > /sys/kernel/mm/transparent_hugepage/enabled
  - echo never > /sys/kernel/mm/transparent_hugepage/defrag
runcmd:
  - yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
EOF
}

