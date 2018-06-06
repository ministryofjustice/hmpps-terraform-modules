variable "s3_bucket_name" {}

variable "acl" {
  default = "private"
}

variable "tags" {
  type = "map"
}
