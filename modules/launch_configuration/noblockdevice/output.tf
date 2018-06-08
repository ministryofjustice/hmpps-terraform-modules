output "launch_id" {
  value = "${aws_launch_configuration.environment.id}"
}

output "launch_name" {
  value = "${aws_launch_configuration.environment.name}"
}
