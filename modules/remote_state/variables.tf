variable "remote_state_bucket_name" {
  description = "resource label or name"
}

variable "kms_key_arn" {}

variable "tags" {
  type = "map"
}
