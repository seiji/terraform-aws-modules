terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "alb-asg-lc.examples"
    encrypt        = true
    dynamodb_table = "terraform-aws-modules-tfstate-lock"
  }
}

provider aws {
  version = "~> 2.39"
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
  namespace = "alb-asg-lc"
  stage     = "staging"
  vpc = {
    id                        = data.terraform_remote_state.vpc.outputs.id
    default_security_group_id = data.terraform_remote_state.vpc.outputs.default_security_group_id
    private_subnet_ids        = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    public_subnet_ids         = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  }
}

module ami {
  source = "../../ami-amzn2"
}

module iam_role_ec2 {
  source    = "../../iam-role-ec2"
  namespace = local.namespace
  stage     = local.stage
}

module lc {
  source                      = "../../ec2-launch"
  namespace                   = local.namespace
  stage                       = local.stage
  ami_block_device_mappings   = module.ami.block_device_mappings
  associate_public_ip_address = false
  iam_instance_profile        = module.iam_role_ec2.instance_profile_id
  image_id                    = module.ami.id
  instance_type               = "t3a.micro"
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

module alb_tg {
  source            = "../../alb-target-group"
  namespace         = local.namespace
  stage             = local.stage
  name              = "alb-asg-lc"
  vpc_id            = local.vpc.id
  port              = 80
  protocol          = "HTTP"
  health_check_path = "/"
}

module asg {
  source               = "../../ec2-asg-lc"
  namespace            = local.namespace
  stage                = local.stage
  name                 = "alb-asg-lc"
  max_size             = 1
  min_size             = 1
  desired_capacity     = 1
  health_check_type    = "ELB"
  target_group_arns    = [module.alb_tg.arn]
  launch_configuration = module.lc.configuration_name
  vpc_zone_identifier  = local.vpc.private_subnet_ids
}

module sg_http {
  source      = "../../vpc-sg"
  namespace   = local.namespace
  stage       = local.stage
  name        = "alb_80"
  vpc_id      = local.vpc.id
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

module sg_https {
  source      = "../../vpc-sg"
  namespace   = local.namespace
  stage       = local.stage
  name        = "alb_443"
  vpc_id      = local.vpc.id
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
  vpc_id           = local.vpc.id
  security_groups  = [local.vpc.default_security_group_id, module.sg_https.id, module.sg_http.id]
  subnets          = local.vpc.public_subnet_ids
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
