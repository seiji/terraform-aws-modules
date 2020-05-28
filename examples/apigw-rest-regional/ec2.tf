data aws_ssm_parameter ami_amzn2 {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

module launch {
  source    = "../../ec2-launch"
  namespace = local.namespace
  stage     = local.stage
  ami_block_device_mappings = [{
    device_name = "/dev/xvda"
  }]
  associate_public_ip_address = false
  iam_instance_profile        = "ecsInstanceRole"
  image_id                    = data.aws_ssm_parameter.ami_amzn2.value
  image_name                  = "amzn2"
  key_name                    = "id_rsa"
  security_groups             = [local.vpc.default_security_group_id]
}

module asg {
  source                                   = "../../ec2-asg-lt"
  namespace                                = local.namespace
  stage                                    = local.stage
  name                                     = module.launch.template_name
  instance_types                           = ["t3.nano"]
  max_size                                 = 1
  min_size                                 = 1
  desired_capacity                         = 1
  health_check_type                        = "EC2"
  launch_template_id                       = module.launch.template_id
  on_demand_base_capacity                  = 0
  on_demand_percentage_above_base_capacity = 0
  vpc_zone_identifier                      = local.vpc.private_subnet_ids
}
