variable "environment" {}
variable "project" {}
variable "loggroupname" {}
variable "cloudwatch_log_retention" {}

variable "business_unit" {
  description = "The name of our business unit, i.e. development."
}

variable "region" {
  description = "The AWS region."
}
