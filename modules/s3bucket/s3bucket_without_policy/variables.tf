variable "environment" {}
variable "project" {}
variable "s3_bucket_name" {}

variable "acl" {
  default = "private"
}

variable "business_unit" {
  description = "The name of our business unit, i.e. development."
}

variable "region" {
  description = "The AWS region."
}
