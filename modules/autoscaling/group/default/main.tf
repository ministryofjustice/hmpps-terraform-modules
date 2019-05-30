locals {
  tags = "${var.tags}"
}

data "null_data_source" "tags" {
  count = "${length(keys(local.tags))}"

  inputs = {
    key                 = "${element(keys(local.tags), count.index)}"
    value               = "${element(values(local.tags), count.index)}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "environment" {
  name                 = "${var.asg_name}"
  vpc_zone_identifier  = ["${var.subnet_ids}"]
  min_size             = "${var.asg_min}"
  max_size             = "${var.asg_max}"
  desired_capacity     = "${var.asg_desired}"
  launch_configuration = "${var.launch_configuration}"

  lifecycle {
    create_before_destroy = true
  }

  tags = [
    "${data.null_data_source.tags.*.outputs}",
    {
      key                 = "Name"
      value               = "${var.asg_name}-asg"
      propagate_at_launch = true
    },
  ]
}
