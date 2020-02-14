terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  version = ">= 2.48"
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
  namespace = "alb-ecs-ec2"
  stage     = "staging"
  vpc = {
    id                        = data.terraform_remote_state.vpc.outputs.id
    default_security_group_id = data.terraform_remote_state.vpc.outputs.default_security_group_id
    private_subnet_ids        = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    public_subnet_ids         = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  }
  cluster_name = "alb-ecs-ec2-staging"
}

module iam_role_ecs {
  source = "../../iam-role-ecs"
}

module ami {
  source = "git::https://github.com/seiji/terraform-aws-ecs-ami.git?ref=master"
}

module launch {
  source                      = "../../ec2-launch"
  namespace                   = local.namespace
  stage                       = local.stage
  ami_block_device_mappings   = module.ami.block_device_mappings
  associate_public_ip_address = false
  iam_instance_profile        = module.iam_role_ecs.instance_profile_id
  image_id                    = module.ami.id
  image_name                  = "amzn2-ecs"
  key_name                    = "id_rsa"
  security_groups             = [local.vpc.default_security_group_id]
  ecs_cluster_name            = local.cluster_name
  root_block_device_size      = 30 # >= 30GB
}

module asg {
  source              = "../../ec2-asg-lt"
  namespace           = local.namespace
  stage               = local.stage
  name                = module.launch.template_name
  instance_types      = ["t3.micro"]
  max_size            = 10
  min_size            = 0
  desired_capacity    = 0
  health_check_type   = "EC2"
  launch_template_id  = module.launch.template_id
  vpc_zone_identifier = local.vpc.private_subnet_ids
}

module alb_tg {
  source            = "../../alb-target-group"
  namespace         = local.namespace
  stage             = local.stage
  vpc_id            = local.vpc.id
  port              = 80
  protocol          = "HTTP"
  health_check_path = "/"
  target_type       = "ip" # awsvpc
}

module sg_https {
  source      = "../../vpc-sg-https"
  namespace   = local.namespace
  stage       = local.stage
  vpc_id      = local.vpc.id
  cidr_blocks = ["0.0.0.0/0"]
}

data aws_acm_certificate this {
  domain      = "*.seiji.me"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data aws_route53_zone this {
  name         = "seiji.me."
  private_zone = false
}

module alb {
  source           = "../../alb-https"
  namespace        = local.namespace
  stage            = local.stage
  vpc_id           = local.vpc.id
  security_groups  = [local.vpc.default_security_group_id, module.sg_https.id]
  subnets          = local.vpc.public_subnet_ids
  certificate_arn  = data.aws_acm_certificate.this.arn
  target_group_arn = module.alb_tg.arn
}

module route53_record_alias {
  source        = "../../route53-record-alias"
  name          = "${local.namespace}.seiji.me"
  zone_id       = data.aws_route53_zone.this.zone_id
  alias_name    = module.alb.dns_name
  alias_zone_id = module.alb.zone_id
}

module ecs {
  source                = "../../ecs-ec2"
  namespace             = local.namespace
  stage                 = local.stage
  autoscaling_group_arn = module.asg.arn
  ecs_task_definition   = "nginx-html"
  min_capacity          = 1
  max_capacity          = 10
  desired_capacity      = 3
  subnets               = local.vpc.private_subnet_ids
  security_groups       = [local.vpc.default_security_group_id]
  lb_container_name     = "nginx"
  lb_container_port     = 80
  lb_target_group_arn   = module.alb_tg.arn
}

