# cert
output "cert_pem" {
  value = "${tls_self_signed_cert.ca.cert_pem}"
}
