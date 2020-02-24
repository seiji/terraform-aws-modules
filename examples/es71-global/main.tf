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
  namespace = "es71-vpc"
  stage     = "staging"
  vpc = {
    id                        = data.terraform_remote_state.vpc.outputs.id
    default_security_group_id = data.terraform_remote_state.vpc.outputs.default_security_group_id
    private_subnet_ids        = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    public_subnet_ids         = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  }
}

module es {
  source                = "../../es-vpc"
  namespace             = local.namespace
  stage                 = local.stage
  elasticsearch_version = "7.1"
  # vpc_options = {
  #   enabled          = true
  #   subnet_ids            = [local.vpc.public_subnet_ids[0]]
  #   security_group_ids    = [local.vpc.default_security_group_id]
  # }
  cluster_config = {
    instance_type            = "t2.small.elasticsearch"
    instance_count           = 1
    dedicated_master_enabled = false
    availability_zone_count  = 1
  }
  allowed_ips = ["124.155.111.68/32"]
}

# module ami {
#   source = "../../ami-amzn2"
# }
#
# module sg_ssh {
#   source      = "../../vpc-sg"
#   namespace   = local.namespace
#   stage       = local.stage
#   vpc_id      = local.vpc.id
#   from_port   = 22
#   to_port     = 22
#   protocol    = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
# }
#
# resource aws_instance tunnel {
#   ami           = module.ami.id
#   instance_type = "t3.micro"
#   subnet_id     = local.vpc.public_subnet_ids[0]
#   vpc_security_group_ids = [
#     local.vpc.default_security_group_id,
#     module.sg_ssh.id,
#   ]
#   associate_public_ip_address = true
#   key_name                    = "id_rsa"
# }
