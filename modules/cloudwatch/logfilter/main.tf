resource "aws_cloudwatch_log_metric_filter" "environment" {
  name            = "tf-${var.project}-${var.environment}-${var.pattern}"
  pattern         = "\"${var.pattern}\""
  log_group_name  = "${var.log_group_name}"

  metric_transformation {
    name          = "${var.metricname}"
    namespace     = "${var.metric_namespace}"
    value         = "${var.metric_value}"
    default_value = "${var.default_metric_value}"
  }
}
