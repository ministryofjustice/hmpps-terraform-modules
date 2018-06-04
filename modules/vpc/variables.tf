variable "vpc_name" {
  description = "resource label or name"
}

variable "region" {
  description = "The AWS region."
}

variable "environment" {
  description = "The name of our environment"
}

variable "enable_dns_hostnames" {
  description = "Should be true if you want to use private DNS within the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true if you want to use private DNS within the VPC"
  default     = true
}

variable "vpc_dns_hosts" {
  description = "A list of Availability zones in the region"
}

variable "project" {
  description = "The name of the project"
}

variable "business_unit" {
  description = "The name of our business unit, i.e. development."
}

variable "route53_domain_private" {}

variable "cidr_block" {
  description = "The CIDR of the VPC."
}
