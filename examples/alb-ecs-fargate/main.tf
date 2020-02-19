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
  namespace = "alb-ecs-fargate"
  stage     = "staging"
  vpc = {
    id                        = data.terraform_remote_state.vpc.outputs.id
    default_security_group_id = data.terraform_remote_state.vpc.outputs.default_security_group_id
    private_subnet_ids        = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    public_subnet_ids         = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  }
  cluster_name = "alb-ecs-fargate-staging"
}

module iam_role_ecs {
  source = "../../iam-role-ecs"
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

module alb {
  source          = "../../alb"
  namespace       = local.namespace
  stage           = local.stage
  vpc_id          = local.vpc.id
  subnets         = local.vpc.public_subnet_ids
  security_groups = [local.vpc.default_security_group_id, module.sg_https.id]
  certificate_arn = data.aws_acm_certificate.this.arn
  tg_port         = 80
  tg_protocol     = "HTTP"
  tg_health_check = {
    enabled             = true
    healthy_threshold   = 3
    interval            = 30
    path                = "/"
    timeout             = 5
    unhealthy_threshold = 3
  }
  tg_target_type = "ip" # awsvpc
}

module ecs {
  source              = "../../ecs-fargate"
  namespace           = local.namespace
  stage               = local.stage
  ecs_task_definition = "nginx-html"
  subnets             = local.vpc.private_subnet_ids
  security_groups     = [local.vpc.default_security_group_id]
  lb_container_name   = "nginx"
  lb_container_port   = 80
  lb_target_group_arn = module.alb.tg_arn
}

data aws_route53_zone this {
  name         = "seiji.me."
  private_zone = false
}

module route53_record_alias {
  source        = "../../route53-record-alias"
  name          = "${local.namespace}.seiji.me"
  zone_id       = data.aws_route53_zone.this.zone_id
  alias_name    = module.alb.lb_dns_name
  alias_zone_id = module.alb.lb_zone_id
}

