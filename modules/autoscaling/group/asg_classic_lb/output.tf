output "autoscale_id" {
  value = "${aws_autoscaling_group.environment.id}"
}
output "autoscale_arn" {
  value = "${aws_autoscaling_group.environment.arn}"
}
output "autoscale_name" {
  value = "${aws_autoscaling_group.environment.name}"
}
