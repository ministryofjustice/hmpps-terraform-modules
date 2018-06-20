resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = "${var.availability_zone}"
  size              = "${var.volume_size}"
  encrypted         = "${var.encrypted}"

  tags = "${merge(
    var.tags,
    map("Name", "${var.app_name}"),
    map("CreateSnapshot", "${var.CreateSnapshot}")
  )}"
}
