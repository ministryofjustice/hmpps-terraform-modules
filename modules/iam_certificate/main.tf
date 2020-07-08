resource "aws_iam_server_certificate" "iam_cert" {
  name_prefix       = var.name_prefix
  certificate_body  = var.certificate_body
  private_key       = var.private_key
  certificate_chain = var.certificate_chain
  path              = var.path

  lifecycle {
    create_before_destroy = true
  }
}

