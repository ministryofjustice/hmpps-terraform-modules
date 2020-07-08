resource "aws_cloudwatch_metric_alarm" "environment" {
  alarm_name                = "tf-${var.pattern}-${var.project}-${var.environment}"
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name
  namespace                 = var.metric_namespace
  period                    = var.period
  statistic                 = var.statistic
  threshold                 = var.threshold
  alarm_description         = "${var.alarm_source} ${var.alarm_source_value} Alarm Send to ${var.slack_project_code}"
  actions_enabled           = var.actions_enabled
  treat_missing_data        = var.treat_missing_data
  ok_actions                = var.ok_actions
  alarm_actions             = var.alarm_actions
  insufficient_data_actions = var.insufficient_data_actions
  datapoints_to_alarm       = var.datapoints_to_alarm
}

