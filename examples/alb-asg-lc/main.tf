terraform {
  required_version = "~> 0.12.0"
}

provider aws {
  version = ">= 2.50"
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

module launch {
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

data aws_acm_certificate this {
  domain      = "*.seiji.me"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

module alb {
  source          = "../../alb"
  namespace       = local.namespace
  stage           = local.stage
  vpc_id          = local.vpc.id
  subnets         = local.vpc.public_subnet_ids
  security_groups = [local.vpc.default_security_group_id, module.sg_https.id]
  listener = {
    certificate_arn = data.aws_acm_certificate.this.arn
    default_action = {
      type           = "forward"
      fixed_response = null
    }
    rules = []
  }
  target_group = {
    deregistration_delay = 300
    health_check = {
      enabled             = true
      healthy_threshold   = 2
      interval            = 30
      path                = "/"
      port                = "traffic-port"
      timeout             = 5
      unhealthy_threshold = 10
    }
    port = 80
    stickiness = {
      cookie_duration = null
      enabled         = false
      type            = null
    }
    target_type = "ip"
  }
}

module asg {
  source               = "../../ec2-asg-lc"
  namespace            = local.namespace
  stage                = local.stage
  name                 = "alb-asg-lc"
  max_size             = 1
  min_size             = 1
  health_check_type    = "ELB"
  target_group_arns    = [module.alb.tg_arn]
  launch_configuration = module.launch.configuration_name
  vpc_zone_identifier  = local.vpc.private_subnet_ids
}

module sg_https {
  source      = "../../vpc-sg-https"
  namespace   = local.namespace
  stage       = local.stage
  vpc_id      = local.vpc.id
  cidr_blocks = ["0.0.0.0/0"]
}

data aws_route53_zone this {
  name         = "seiji.me."
  private_zone = false
}

module route53_record {
  source  = "../../route53-record"
  name    = "example.seiji.me"
  zone_id = data.aws_route53_zone.this.zone_id
  alias = {
    name    = module.alb.lb_dns_name
    zone_id = module.alb.lb_zone_id
  }
}
