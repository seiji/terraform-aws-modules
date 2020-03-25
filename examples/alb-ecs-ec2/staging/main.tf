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
  cluster_name = join("-", [local.namespace, local.stage])
  # cloud_map_namespace_id = data.terraform_remote_state.vpc.outputs.cloud_map_namespace_id
}

module ami {
  source = "git::https://github.com/seiji/terraform-aws-ecs-ami.git?ref=master"
}

module launch {
  source                      = "../../../ec2-launch"
  namespace                   = local.namespace
  stage                       = local.stage
  ami_block_device_mappings   = module.ami.block_device_mappings
  associate_public_ip_address = false
  iam_instance_profile        = "ecsInstanceRole"
  image_id                    = module.ami.id
  image_name                  = "amzn2-ecs"
  key_name                    = "id_rsa"
  security_groups             = [local.vpc.default_security_group_id]
  ecs_cluster_name            = local.cluster_name
  root_block_device_size      = 30 # >= 30GB
}

module asg {
  source                                   = "../../../ec2-asg-lt"
  namespace                                = local.namespace
  stage                                    = local.stage
  name                                     = module.launch.template_name
  instance_types                           = ["t3a.small", "t3.small"]
  max_size                                 = 4
  min_size                                 = 2
  desired_capacity                         = 0
  health_check_type                        = "EC2"
  launch_template_id                       = module.launch.template_id
  on_demand_base_capacity                  = 0
  on_demand_percentage_above_base_capacity = 0
  vpc_zone_identifier                      = local.vpc.private_subnet_ids
}

module sg_https {
  source      = "../../../vpc-sg-https"
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
    deregistration_delay = 60
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

module ecs {
  source           = "../../../ecs-ec2"
  namespace        = local.namespace
  stage            = local.stage
  aas_max_capacity = 10
  aas_min_capacity = 1
  aas_policy_cpu = {
    enabled        = true
    threshold_high = 60
    threshold_low  = 30
  }
  asg_arn             = module.asg.arn
  ecs_desired_count   = 2
  ecs_task_definition = "alb-ecs-ec2-staging"
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
  ecs_deployment_maximum_percent         = 150
  ecs_deployment_minimum_healthy_percent = 100
  # service_discovery_namespace_id = local.cloud_map_namespace_id
}

data aws_route53_zone this {
  name         = "seiji.me."
  private_zone = false
}

module route53_record_alias {
  source        = "../../../route53-record-alias"
  name          = "${local.namespace}.seiji.me"
  zone_id       = data.aws_route53_zone.this.zone_id
  alias_name    = module.alb.lb_dns_name
  alias_zone_id = module.alb.lb_zone_id
}

