variable "s3_bucket_name" {}

variable "acl" {
  default = "private"
}

variable "tags" {
  type = "map"
}

variable "kms_master_key_id" {
  description = "kms master key id"
}

variable "sse_algorithm" {
  default = "aws:kms"
}

variable "versioning" {
  default = false
}
