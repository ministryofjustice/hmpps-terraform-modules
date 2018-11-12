variable "environment_identifier" {
  description = "resource label or name"
}

variable "short_environment_identifier" {
  description = "short resource label or name"
}

variable "region" {
  description = "The AWS region."
}

variable "instance_type" {}

variable "remote_state_bucket_name" {}

variable "app_name" {}

variable "route53_sub_domain" {}

variable "route53_domain_private" {}

variable "bastion_inventory" {}