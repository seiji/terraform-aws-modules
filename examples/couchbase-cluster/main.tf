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
  region     = "ap-northeast-1"
  namespace  = "couchbase-cluster"
  stage      = "staging"
  cb_version = "6.0.0"
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

module "lc" {
  source                      = "../../ec2-launch-configurations"
  namespace                   = local.namespace
  stage                       = local.stage
  name                        = "couchbase"
  associate_public_ip_address = false
  iam_instance_profile        = module.iam_instance_profile_ec2.id
  image_id                    = "ami-045f38c93733dd48d"
  instance_type               = "t3.micro"
  key_name                    = "id_rsa"
  security_groups             = [module.vpc.default_security_group_id]
  userdata_part_content       = <<EOF
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
  - yum install -y https://packages.couchbase.com/releases/${local.cb_version}/couchbase-server-community-${local.cb_version}-centos7.x86_64.rpm
EOF
}

data "aws_acm_certificate" "this" {
  domain      = "*.seiji.me"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

module "sg_https" {
  source      = "../../vpc-sg"
  namespace   = local.namespace
  stage       = local.stage
  name        = "https"
  vpc_id      = module.vpc.vpc_id
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

module "sg_http" {
  source      = "../../vpc-sg"
  namespace   = local.namespace
  stage       = local.stage
  name        = "http"
  vpc_id      = module.vpc.vpc_id
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

module "alb_tg_rest" {
  source            = "../../alb-target-group"
  namespace         = local.namespace
  stage             = local.stage
  name              = "couchbase-rest"
  vpc_id            = module.vpc.vpc_id
  port              = 8091
  protocol          = "HTTP"
  health_check_path = "/favicon.ico"
}

module "alb" {
  source           = "../../alb-https"
  namespace        = local.namespace
  stage            = local.stage
  name             = "couchbase"
  vpc_id           = module.vpc.vpc_id
  security_groups  = [module.vpc.default_security_group_id, module.sg_https.id, module.sg_http.id]
  subnets          = module.vpc.public_subnet_ids
  certificate_arn  = data.aws_acm_certificate.this.arn
  target_group_arn = module.alb_tg_rest.arn
}

module "asg" {
  source               = "../../ec2-auto-scaling-groups"
  namespace            = local.namespace
  stage                = local.stage
  name                 = "couchbase"
  max_size             = 3
  min_size             = 3
  desired_capacity     = 3
  health_check_type    = "ELB"
  target_group_arns    = [module.alb_tg_rest.arn]
  launch_configuration = module.lc.name
  vpc_zone_identifier  = module.vpc.private_subnet_ids
}

data "aws_route53_zone" "this" {
  name         = "seiji.me."
  private_zone = false
}

module "route53_record_alias" {
  source        = "../../route53-record-alias"
  name          = "cb.seiji.me"
  zone_id       = data.aws_route53_zone.this.zone_id
  alias_name    = module.alb.dns_name
  alias_zone_id = module.alb.zone_id
}

