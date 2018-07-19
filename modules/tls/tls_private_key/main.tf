# KEY 
resource "tls_private_key" "key" {
  algorithm = "${var.algorithm}"
  rsa_bits  = "${var.rsa_bits}"
}
