terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  version = "~> 2.0"
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

module alb_tg {
  source            = "../../alb-target-group"
  namespace         = local.namespace
  stage             = local.stage
  vpc_id            = local.vpc.id
  port              = 80
  protocol          = "HTTP"
  health_check_path = "/"
  target_type       = "ip"
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
  lb_target_group_arn = module.alb_tg.arn
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
  source           = "../../alb-https"
  namespace        = local.namespace
  stage            = local.stage
  vpc_id           = local.vpc.id
  security_groups  = [local.vpc.default_security_group_id, module.sg_https.id]
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
  name          = "${local.namespace}.seiji.me"
  zone_id       = data.aws_route53_zone.this.zone_id
  alias_name    = module.alb.dns_name
  alias_zone_id = module.alb.zone_id
}
