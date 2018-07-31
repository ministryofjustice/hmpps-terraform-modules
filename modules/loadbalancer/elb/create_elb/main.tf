resource "aws_elb" "environment" {
  name            = "${var.name}"
  subnets         = ["${var.subnets}"]
  internal        = "${var.internal}"
  security_groups = ["${var.security_groups}"]

  cross_zone_load_balancing   = "${var.cross_zone_load_balancing}"
  idle_timeout                = "${var.idle_timeout}"
  connection_draining         = "${var.connection_draining}"
  connection_draining_timeout = "${var.connection_draining_timeout}"

  listener = ["${var.listener}"]

  access_logs = {
    bucket        = "${var.bucket}"
    bucket_prefix = "${var.bucket_prefix}"
    interval      = "${var.interval}"
  }

  health_check = ["${var.health_check}"]
  tags         = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}
