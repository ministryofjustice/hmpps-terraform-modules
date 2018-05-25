variable "environment" {}
variable "project" {}
variable "pattern" {}
variable "log_group_name" {}
variable "metricname" {}
variable "metric_namespace" {}

variable "metric_value" {
  default = "1"
}

variable "default_metric_value" {
  default = "0"
}

variable "business_unit" {
  description = "The name of our business unit, i.e. development."
}

variable "region" {
  description = "The AWS region."
}
