variable "region" {}
variable "project" {}

variable "app_name" {
  type = "list"
}

variable "environment" {}

variable "business_unit" {
  description = "The name of our business unit, i.e. development."
}

variable "role_arn" {}
