variable "ca_key_algorithm" {}

variable "cert_request_pem" {}

variable "ca_private_key_pem" {}

variable "ca_cert_pem" {}

variable "validity_period_hours" {}

variable "early_renewal_hours" {}

variable "allowed_uses" {
  type = "list"
}
