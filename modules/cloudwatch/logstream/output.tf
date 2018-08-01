output "logstream_arn" {
  value = "${aws_cloudwatch_log_stream.environment.arn}"
}
