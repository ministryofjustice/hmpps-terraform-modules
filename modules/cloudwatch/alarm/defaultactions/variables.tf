variable "project" {}
variable "environment" {}
variable "pattern" {}

variable "comparison_operator" {
  default = "GreaterThanOrEqualToThreshold"
}

variable "evaluation_periods" {
  default = "1"
}

variable "metric_name" {}
variable "metric_namespace" {}

variable "period" {
  default = "300"
}

variable "statistic" {
  default = "Average"
}

variable "threshold" {}

variable "actions_enabled" {
  default = "true"
}

variable "alarm_source" {}
variable "alarm_source_value" {}
variable "slack_project_code" {}

variable "treat_missing_data" {
  default = "missing"
}

variable "ok_actions" {
  default = []
  type    = "list"
}

variable "alarm_actions" {
  default = []
  type    = "list"
}

variable "insufficient_data_actions" {
  default = []
  type    = "list"
}

variable "datapoints_to_alarm" {
  default = "1"
}

variable "business_unit" {
  description = "The name of our business unit, i.e. development."
}

variable "region" {
  description = "The AWS region."
}
