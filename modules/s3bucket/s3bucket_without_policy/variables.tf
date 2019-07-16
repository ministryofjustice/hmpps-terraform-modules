variable "s3_bucket_name" {}

variable "acl" {
  default = "private"
}

variable "tags" {
  type = "map"
}

variable "versioning" {
  default = true
}

variable "prevent_destroy" {
  default = false
}