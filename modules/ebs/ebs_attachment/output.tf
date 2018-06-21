output "device_name" {
  value = "${aws_volume_attachment.volume_attachment.device_name}"
}

output "instance_id" {
  value = "${aws_volume_attachment.volume_attachment.instance_id}"
}

output "volume_id" {
  value = "${aws_volume_attachment.volume_attachment.volume_id}"
}
