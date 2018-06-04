resource "aws_cloudwatch_log_group" "environment" {
  name              = "tf-${var.prefix}/${var.loggroupname}"
  retention_in_days = "${var.cloudwatch_log_retention}"

  tags {
    Name          = "tf-${var.loggroupname}"
    Project       = "${var.project}"
    Environment   = "${var.environment}"
    Business-Unit = "${var.business_unit}"
  }
}
