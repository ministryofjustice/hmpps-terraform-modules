variable "vpc_name" {
  description = "resource label or name"
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

variable "route53_domain_private" {}

variable "cidr_block" {
  description = "The CIDR of the VPC."
}

variable "tags" {
  type = "map"
}
