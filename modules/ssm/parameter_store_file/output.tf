output "arn" {
  value = "${aws_ssm_parameter.param.arn}"
}

output "name" {
  value = "${aws_ssm_parameter.param.name}"
}
