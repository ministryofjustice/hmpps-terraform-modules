variable "region" {}
variable "environment" {}
variable "project" {}

variable "prefix" {
  description = "resource label or name"
}

variable "hash_key" {}

variable "read_capacity" {
  default = "10"
}

variable "write_capacity" {
  default = "5"
}
