variable "subnet" {}

variable "region" {
  description = "The AWS region."
}

variable "project" {
  description = "The name of our org, i.e. burbank.working-age.local"
}

variable "environment" {
  description = "The name of our environment, i.e. development."
}

variable "business_unit" {
  description = "The name of our business unit, i.e. development."
}

variable "az" {
  description = "Availability zone"
}
