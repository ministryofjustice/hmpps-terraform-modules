output "listener_id" {
  value = "${aws_lb_listener.environment_no_https.*.id}"
}

output "listener_arn" {
  value = "${aws_lb_listener.environment_no_https.*.arn}"
}
