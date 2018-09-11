resource "aws_cloudwatch_log_stream" "environment" {
  count          = "${length(var.log_stream_name)}"
  name           = "${element(var.log_stream_name,count.index)}"
  log_group_name = "${var.log_group_name}"
}
