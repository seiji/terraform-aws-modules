terraform {
  required_version = "~> 0.12.0"
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
  namespace = "ec2-asg-lt"
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

module iam_instance_profile {
  source    = "../../iam-instance-profile-ec2"
  namespace = local.namespace
  stage     = local.stage
}

module launch {
  source                      = "../../ec2-launch"
  namespace                   = local.namespace
  stage                       = local.stage
  ami_block_device_mappings   = module.ami.block_device_mappings
  associate_public_ip_address = false
  iam_instance_profile        = module.iam_instance_profile.id
  image_id                    = module.ami.id
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
