data "terraform_remote_state" "vpc" {
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
  cluster_name = join("-", [local.namespace, local.stage])
}

module "sg_https" {
  source      = "../../../vpc-sg-https"
  namespace   = local.namespace
  stage       = local.stage
  vpc_id      = local.vpc.id
  cidr_blocks = ["0.0.0.0/0"]
}

data "aws_acm_certificate" "this" {
  domain      = "*.seiji.me"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

module "alb" {
  source          = "../../../alb"
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
      unhealthy_threshold = 3
    }
    port = 80
    stickiness = {
      cookie_duration = null
      enabled         = false
      type            = null
    }
    target_type = "ip" # awsvpc
  }
}

module "ecs" {
  source              = "../../../ecs-fargate"
  namespace           = local.namespace
  stage               = local.stage
  ecs_desired_count   = 2
  ecs_task_definition = "alb-ecs-fargate-staging"
  load_balancers = [{
    container_name   = "nginx"
    container_port   = 8080
    target_group_arn = module.alb.tg_arn
  }]
  network_configuration = {
    subnets          = local.vpc.private_subnet_ids
    security_groups  = [local.vpc.default_security_group_id]
    assign_public_ip = false
  }
}

data "aws_route53_zone" "this" {
  name         = "seiji.me."
  private_zone = false
}

module "route53_record" {
  source  = "../../../route53-record"
  name    = "${local.namespace}.seiji.me"
  zone_id = data.aws_route53_zone.this.zone_id
  alias = {
    name    = module.alb.lb_dns_name
    zone_id = module.alb.lb_zone_id
  }
}

