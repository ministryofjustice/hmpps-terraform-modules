output "private_ip" {
  value = "${aws_instance.instance.0.private_ip}"
}

output "private_dns" {
  value = "${aws_instance.instance.0.private_dns}"
}

output "public_ip" {
  value = "${aws_instance.instance.0.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.instance.0.public_dns}"
}

output "instance_id" {
  value = "${aws_instance.instance.0.id}"
}
