terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "alb-ec2.examples"
    encrypt        = true
    dynamodb_table = "terraform-aws-modules-tfstate-lock"
  }
}

provider aws {
  version = "~> 2.22"
  region  = "ap-northeast-1"
}

locals {
  namespace = "alb-ec2"
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
  name                        = "alb-ec2"
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

module alb_tg {
  source            = "../../alb-target-group"
  namespace         = local.namespace
  stage             = local.stage
  name              = "alb-ec2"
  vpc_id            = module.vpc.vpc_id
  port              = 80
  protocol          = "HTTP"
  health_check_path = "/"
}

module asg {
  source               = "../../ec2-auto-scaling-groups"
  namespace            = local.namespace
  stage                = local.stage
  name                 = "alb-ec2"
  max_size             = 1
  min_size             = 1
  desired_capacity     = 1
  health_check_type    = "ELB"
  target_group_arns    = [module.alb_tg.arn]
  launch_configuration = module.lc.configuration_name
  vpc_zone_identifier  = module.vpc.private_subnet_ids
}

module sg_http {
  source      = "../../vpc-sg"
  namespace   = local.namespace
  stage       = local.stage
  name        = "alb_80"
  vpc_id      = module.vpc.vpc_id
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

module "sg_https" {
  source      = "../../vpc-sg"
  namespace   = local.namespace
  stage       = local.stage
  name        = "alb_443"
  vpc_id      = module.vpc.vpc_id
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

data aws_acm_certificate this {
  domain      = "*.seiji.me"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

module alb {
  source           = "../../alb-https"
  namespace        = local.namespace
  stage            = local.stage
  name             = "alb-ec2"
  vpc_id           = module.vpc.vpc_id
  security_groups  = [module.vpc.default_security_group_id, module.sg_https.id, module.sg_http.id]
  subnets          = module.vpc.public_subnet_ids
  certificate_arn  = data.aws_acm_certificate.this.arn
  target_group_arn = module.alb_tg.arn
}

data aws_route53_zone this {
  name         = "seiji.me."
  private_zone = false
}

module route53_record_alias {
  source        = "../../route53-record-alias"
  name          = "example.seiji.me"
  zone_id       = data.aws_route53_zone.this.zone_id
  alias_name    = module.alb.dns_name
  alias_zone_id = module.alb.zone_id
}
