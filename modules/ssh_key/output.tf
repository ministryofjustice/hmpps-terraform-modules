output "public_key_openssh" {
  value = "${tls_private_key.environment.public_key_openssh}"
}

output "private_key_pem" {
  value = "${tls_private_key.environment.private_key_pem}"
}

output "deployer_key" {
  value = "${aws_key_pair.environment.key_name}"
}
