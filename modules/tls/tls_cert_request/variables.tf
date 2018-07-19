variable "key_algorithm" {}

variable "private_key_pem" {}

variable "dns_names" {
  type    = "list"
  default = []
}

variable "subject" {
  type = "list"
}
