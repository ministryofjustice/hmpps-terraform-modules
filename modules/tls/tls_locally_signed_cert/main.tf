resource "tls_locally_signed_cert" "server" {
  cert_request_pem      = "${var.cert_request_pem}"
  ca_key_algorithm      = "${var.ca_key_algorithm}"
  ca_private_key_pem    = "${var.ca_private_key_pem}"
  ca_cert_pem           = "${var.ca_cert_pem}"
  validity_period_hours = "${var.validity_period_hours}"
  early_renewal_hours   = "${var.early_renewal_hours}"

  allowed_uses = ["${var.allowed_uses}"]
}
