variable "environment" {}
variable "region" {}
variable "project" {}
variable "kms_key_name" {}

variable "deletion_window_in_days" {
  default = "7"
}

variable "is_enabled" {
  default = "true"
}

variable "enable_key_rotation" {
  default = "true"
}

variable "business_unit" {
  description = "The name of our business unit, i.e. development."
}
