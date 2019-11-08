resource "aws_appautoscaling_target" "this" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  # role_arn           = data.aws_iam_role.ecs_autoscale_service_linked_role.arn
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
}

resource "aws_appautoscaling_policy" "scale_out" {
  name                    = "${local.name}-scale-out"
  resource_id             = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  depends_on              = ["aws_appautoscaling_target.this"]
  scalable_dimension      = "${aws_appautoscaling_target.this.scalable_dimension}"
  service_namespace       = "${aws_appautoscaling_target.this.service_namespace}"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_appautoscaling_policy" "scale_in" {
  name                    = "${local.name}-scale-in"
  resource_id             = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  depends_on              = ["aws_appautoscaling_target.this"]
  scalable_dimension      = "${aws_appautoscaling_target.this.scalable_dimension}"
  service_namespace       = "${aws_appautoscaling_target.this.service_namespace}"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${local.name}-scale-out"
  adjustment_type         = "ChangeInCapacity"
  cooldown               = 300
  scaling_adjustment     = 1
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${local.name}-scale-in"
  adjustment_type         = "ChangeInCapacity"
  cooldown               = 300
  scaling_adjustment     = -1
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_autoscaling_group" "this" {
  desired_capacity          = var.desired_capacity
  health_check_grace_period = 0
  health_check_type         = "EC2"
  launch_configuration      = aws_launch_configuration.this.name
  max_size                  = var.max_capacity
  min_size                  = var.min_capacity
  name                      = var.namespace
  vpc_zone_identifier       = var.subnet_private_id_list

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "namespace"
    value               = var.namespace
    propagate_at_launch = "true"
  }

  tag {
    key                 = "stage"
    value               = var.stage
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Name"
    value               = local.name
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "this" {
  name_prefix          = "${var.namespace}-"
  image_id             = var.image_id
  instance_type        = var.instance_type
  iam_instance_profile = var.ec2_iam_role
  key_name             = var.key_name
  security_groups      = var.ec2_security_id_list

  associate_public_ip_address = false
  enable_monitoring           = false
  ebs_optimized               = false

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  user_data                   = <<EOF
  #!/bin/bash
  echo ECS_CLUSTER=${local.name} >> /etc/ecs/ecs.config
  EOF
}
