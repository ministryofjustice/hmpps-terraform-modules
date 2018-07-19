variable "validity_period_hours" {}

variable "early_renewal_hours" {}

variable "is_ca_certificate" {
  default = false
}

variable "private_key_pem" {}

variable "subject" {
  type = "list"
}

variable "allowed_uses" {
  type = "list"
}

variable "key_algorithm" {}
