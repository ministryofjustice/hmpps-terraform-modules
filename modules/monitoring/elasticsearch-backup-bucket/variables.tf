variable "acl" {
  default = "private"
}

variable "bucket_name" {}

variable "tags" {
  type = "map"
}

variable "vpc_cidr" {}

variable "account_id" {}