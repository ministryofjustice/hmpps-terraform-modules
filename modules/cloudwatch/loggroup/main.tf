resource "aws_cloudwatch_log_group" "environment" {
  name              = "${var.log_group_path}/${var.loggroupname}"
  retention_in_days = "${var.cloudwatch_log_retention}"
  tags              = "${merge(var.tags, map("name", "tf-${var.loggroupname}"))}"
}
