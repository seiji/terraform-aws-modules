terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "couchbase-cluster.examples"
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
  namespace = "couchbase-cluster"
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

module "iam_instance_profile_ec2" {
  source    = "../../iam-instance-profile-ec2"
  namespace = local.namespace
  stage     = local.stage
}

module "sg_ssh" {
  source      = "../../vpc-sg"
  namespace   = local.namespace
  stage       = local.stage
  name        = "ssh"
  vpc_id      = module.vpc.vpc_id
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

module "ec2_lc" {
  source               = "../../ec2-launch-configurations"
  namespace            = local.namespace
  stage                = local.stage
  name                 = "couchbase"
  associate_public_ip_address = true
  iam_instance_profile = module.iam_instance_profile_ec2.id
  image_id             = "ami-045f38c93733dd48d"
  instance_type        = "t3.micro"
  key_name             = "id_rsa"
  security_groups      =  [module.vpc.default_security_group_id, module.sg_ssh.id]
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
EOF
}

module "ec2_asg" {
  source               = "../../ec2-auto-scaling-groups"
  namespace            = local.namespace
  stage                = local.stage
  name                 = "couchbase"
  max_size             = 3
  min_size             = 1
  desired_capacity     = 1
  launch_configuration = module.ec2_lc.name
  vpc_zone_identifier  = module.vpc.public_subnet_ids
}

#
# module "ec2_private" {
#   source                      = "../../ec2"
#   region                      = local.region
#   service                     = "example"
#   env                         = "production"
#   name                        = "private"
#   image_id                    = "ami-045f38c93733dd48d"
#   instance_type               = "t3.micro"
#   vpc_id                      = module.vpc.vpc_id
#   associate_public_ip_address = false
#   subnet_private_id_list      = data.aws_subnet_ids.private.ids
#   subnet_public_id_list       = data.aws_subnet_ids.public.ids
#   security_id_list            = [data.aws_security_group.default.id]
#   key_name                    = "id_rsa"
#
#   userdata_part_content = <<EOF
# #cloud-config
# repo_update: true
# repo_upgrade: none
# timezone: Asia/Tokyo
# locale: ja_JP.UTF-8
# bootcmd:
#   - |
#     rm -f /etc/sysconfig/network-scripts/ifcfg-eth0
#     for PATH_DHCLIENT_PID in /var/run/dhclient*; do
#         export PATH_DHCLIENT_PID
#         dhclient -r
#         # Making sure it really truly stopped
#         kill $(<PATH_DHCLIENT_PID) || true
#         rm -f "$PATH_DHCLIENT_PID"
#     done
#     systemctl restart network
#   - sysctl vm.swappiness=0
#   - echo never > /sys/kernel/mm/transparent_hugepage/enabled
#   - echo never > /sys/kernel/mm/transparent_hugepage/defrag
# runcmd:
#   - yum install -y https://packages.couchbase.com/releases/${cb_version}/couchbase-server-community-${cb_version}-centos7.x86_64.rpm
# EOF
# }
#
