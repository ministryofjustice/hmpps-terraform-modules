resource "aws_cloudwatch_log_group" "environment" {
  name              = "tf-${var.region}-${var.business_unit}-${var.project}/${var.environment}/${var.loggroupname}"
  retention_in_days = "${var.cloudwatch_log_retention}"

  tags {
    Name          = "tf-${var.region}-${var.business_unit}-${var.project}-${var.environment}-${var.loggroupname}"
    Project       = "${var.project}"
    Environment   = "${var.environment}"
    Business-Unit = "${var.business_unit}"
  }
}
