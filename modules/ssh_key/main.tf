resource "tls_private_key" "environment" {
  algorithm = "RSA"
  rsa_bits  = var.rsa_bits
}

resource "aws_key_pair" "environment" {
  key_name   = "${var.keyname}-ssh-key"
  public_key = tls_private_key.environment.public_key_openssh
}

