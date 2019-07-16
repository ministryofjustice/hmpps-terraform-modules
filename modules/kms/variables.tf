variable "kms_key_name" {}

variable "deletion_window_in_days" {
  default = "7"
}

variable "is_enabled" {
  default = "true"
}

variable "enable_key_rotation" {
  default = "true"
}

variable "kms_policy_location" {
  default = "policies/kms-policy.json"
}


variable "tags" {
  type = "map"
}
