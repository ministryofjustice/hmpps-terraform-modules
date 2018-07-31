resource "aws_autoscaling_group" "environment" {
  name                 = "${var.asg_name}"
  vpc_zone_identifier  = ["${var.subnet_ids}"]
  min_size             = "${var.asg_min}"
  max_size             = "${var.asg_max}"
  desired_capacity     = "${var.asg_desired}"
  launch_configuration = "${var.launch_configuration}"
  load_balancers       = ["${var.load_balancers}"]

  lifecycle {
    create_before_destroy = true
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.asg_name}-asg"
      propagate_at_launch = true
    },
  ]
}
