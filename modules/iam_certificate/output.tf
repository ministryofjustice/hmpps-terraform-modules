output "name" {
  value = "${aws_iam_server_certificate.iam_cert.name}"
}

output "id" {
  value = "${aws_iam_server_certificate.iam_cert.id}"
}

output "arn" {
  value = "${aws_iam_server_certificate.iam_cert.arn}"
}

output "path" {
  value = "${var.path}"
}
