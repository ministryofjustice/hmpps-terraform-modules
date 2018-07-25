# cert
output "cert_pem" {
  value = "${tls_locally_signed_cert.server.cert_pem}"
}
