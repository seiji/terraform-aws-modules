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
  namespace = "ec2-instance-connect"
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

module sg_ssh {
  source      = "../../vpc-sg"
  namespace   = local.namespace
  stage       = local.stage
  vpc_id      = local.vpc.id
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # use ip of your network and aws range
}

module launch {
  source                      = "../../ec2-launch"
  namespace                   = local.namespace
  stage                       = local.stage
  ami_block_device_mappings   = module.ami.block_device_mappings
  associate_public_ip_address = true
  image_id                    = module.ami.id
  instance_type               = "t3.nano"
  key_name                    = "id_rsa"
  security_groups             = [local.vpc.default_security_group_id, module.sg_ssh.id]
  spot_price                  = "0.002"
}

module bastion {
  source               = "../../ec2-asg-lc"
  namespace            = local.namespace
  stage                = local.stage
  name                 = module.launch.configuration_name
  max_size             = 1
  min_size             = 1
  health_check_type    = "EC2"
  launch_configuration = module.launch.configuration_name
  vpc_zone_identifier  = local.vpc.public_subnet_ids
}
