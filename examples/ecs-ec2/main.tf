terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  version = "~> 2.40"
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
  namespace = "ecs-ec2"
  stage     = "staging"
  vpc = {
    id                        = data.terraform_remote_state.vpc.outputs.id
    default_security_group_id = data.terraform_remote_state.vpc.outputs.default_security_group_id
    private_subnet_ids        = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    public_subnet_ids         = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  }
  cluster_name = "ecs-ec2-staging"
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
  instance_types      = ["t3a.micro"]
  max_size            = 1
  min_size            = 1
  desired_capacity    = 1
  health_check_type   = "EC2"
  launch_template_id  = module.launch.template_id
  vpc_zone_identifier = local.vpc.private_subnet_ids
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

module ecs_ec2 {
  source            = "../../ecs-ec2"
  namespace         = local.namespace
  stage             = local.stage
  acm_arn           = data.aws_acm_certificate.this.arn
  alb_security_ids  = [local.vpc.default_security_group_id, module.sg_https.id]
  container_name    = "nginx"
  container_port    = 80
  ecs_cluster_name  = local.cluster_name
  ecs_iam_role      = "ecsServiceRole"
  subnet_public_ids = local.vpc.public_subnet_ids
  vpc_id            = local.vpc.id
}

data aws_route53_zone this {
  name         = "seiji.me."
  private_zone = false
}

module route53_record_alias {
  source        = "../../route53-record-alias"
  name          = "nginx.seiji.me"
  zone_id       = data.aws_route53_zone.this.zone_id
  alias_name    = module.ecs_ec2.alb_dns_name
  alias_zone_id = module.ecs_ec2.alb_zone_id
}

module cloudwatch_log_group {
  source            = "../../cloudwatch-log-group"
  namespace         = local.namespace
  stage             = local.stage
  name              = "examples/ecs-ec2"
  retention_in_days = 3
}

module cloudwatch_log_s3 {
  source    = "../../s3"
  namespace = local.namespace
  stage     = local.stage
}

module kinesis_firehose_s3 {
  source         = "../../kinesis-firehose-s3"
  namespace      = local.namespace
  stage          = local.stage
  bucket_arn     = module.cloudwatch_log_s3.arn
  log_group_name = module.cloudwatch_log_group.name
}

module cloudwatch_log_subscription_filter {
  source          = "../../cloudwatch-log-subscription-filter"
  namespace       = local.namespace
  stage           = local.stage
  destination_arn = module.kinesis_firehose_s3.arn
  log_group_name  = module.cloudwatch_log_group.name
}
