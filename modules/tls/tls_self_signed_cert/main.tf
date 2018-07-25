# CA CERT
resource "tls_self_signed_cert" "ca" {
  key_algorithm         = "${var.key_algorithm}"
  private_key_pem       = "${var.private_key_pem}"
  subject               = ["${var.subject}"]
  validity_period_hours = "${var.validity_period_hours}"
  early_renewal_hours   = "${var.early_renewal_hours}"
  is_ca_certificate     = "${var.is_ca_certificate}"
  allowed_uses          = ["${var.allowed_uses}"]
}
