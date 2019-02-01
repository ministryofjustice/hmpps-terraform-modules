resource "aws_autoscaling_lifecycle_hook" "asg_instance_launch" {
  count                  = "${var.asg_instance_launch_count}"
  name                   = "${var.asg_name}-launching"
  autoscaling_group_name = "${var.asg_name}"
  default_result         = "CONTINUE"
  heartbeat_timeout      = 2000
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"

  notification_metadata = <<EOF
  {
    "fqdn": "${var.fqdn}",
    "zone_id": "${var.zone_id}",
    "private_dns": "${var.private_dns}",
    "action": "register"
  }
  EOF

  notification_target_arn = "${var.sns_notifcaftion_arn}"
  role_arn                = "${var.sns_role_arn}"
}

resource "aws_autoscaling_lifecycle_hook" "asg_instance_terminate" {
  count                  = "${var.asg_instance_terminating_count}"
  name                   = "${var.asg_name}-terminating"
  autoscaling_group_name = "${var.asg_name}"
  default_result         = "CONTINUE"
  heartbeat_timeout      = 2000
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"

  notification_metadata = <<EOF
  {
    "fqdn": "${var.fqdn}",
    "zone_id": "${var.zone_id}",
    "private_dns": "${var.private_dns}",
    "action": "deregister"
  }
  EOF

  notification_target_arn = "${var.sns_notifcaftion_arn}"
  role_arn                = "${var.sns_role_arn}"
}