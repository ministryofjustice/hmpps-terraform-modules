resource "aws_cloudwatch_log_stream" "environment" {
  name           = "${var.log_stream_name}"
  log_group_name = "${var.log_group_name}"
}
