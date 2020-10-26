locals {
  tags = var.tags
}

resource "aws_autoscaling_group" "environment" {
  name                 = var.asg_name
  vpc_zone_identifier  = var.subnet_ids
  min_size             = var.asg_min
  max_size             = var.asg_max
  desired_capacity     = var.asg_desired
  launch_configuration = var.launch_configuration

  lifecycle {
    create_before_destroy = true
  }

  # Convert tag list to a map
  tags = [
    for key, value in merge(var.tags, {
      "Name" = "${var.asg_name}-asg"
    }) : {
      key                 = key
      value               = value
      propagate_at_launch = true
    }
  ]
}

