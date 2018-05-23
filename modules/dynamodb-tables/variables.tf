variable "region" {}
variable "environment" {}
variable "project" {}
variable "app_name" {}
variable "dynamotable_name" {}
variable "hash_key" {}
variable "read_capacity" {
  default = "10"
}
variable "write_capacity" {
  default = "5"
}
