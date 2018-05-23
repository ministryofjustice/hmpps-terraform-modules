variable "region" {
  description = "The AWS region."
}

variable "environment" {
  description = "The name of our environment"
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  default     = false
}

variable "business_unit" {
  description = "The name of our business unit, i.e. development."
}

variable "project" {
  description = "The name of our project"
}

variable "subnet_cidr_block" {
  default = ["192.168.0.0/24"]
}

variable "availability_zone" {}
variable "subnet_name" {}
variable "vpc_id" {}
