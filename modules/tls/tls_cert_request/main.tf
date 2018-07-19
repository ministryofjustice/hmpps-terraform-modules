resource "tls_cert_request" "server" {
  key_algorithm   = "${var.key_algorithm}"
  private_key_pem = "${var.private_key_pem}"
  subject         = ["${var.subject}"]
  dns_names       = ["${var.dns_names}"]
}
