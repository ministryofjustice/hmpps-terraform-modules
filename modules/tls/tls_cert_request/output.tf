# csr
output "cert_request_pem" {
  value = "${tls_cert_request.server.cert_request_pem}"
}
