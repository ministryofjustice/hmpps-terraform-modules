resource "aws_volume_attachment" "volume_attachment" {
  device_name = "${var.device_name}"
  instance_id = "${var.instance_id}"
  volume_id   = "${var.volume_id}"
}
