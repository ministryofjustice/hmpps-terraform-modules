#-------------------------------------------------------------
### EBS Volumes
#-------------------------------------------------------------

resource "aws_ebs_volume" "nfs_data_disk" {
  count                   = "${var.volume_count}"
  availability_zone       = "${var.availability_zones[1]}"
  size                    = "${var.nfs_volume_size}"
  encrypted               = true

  tags = "${merge(
    var.tags,
    map("Name", "${var.environment_identifier}-${local.app_name}"),
    map("CreateSnapshot", true)
  )}"
}

resource "aws_volume_attachment" "nfs_data_volume_attachment" {
  count        = "${var.volume_count}"
  device_name  = "${element(local.device_list, count.index )}"
  instance_id  = "${module.create-ec2-instance.instance_id}"
  volume_id    = "${element(aws_ebs_volume.nfs_data_disk.*.id, count.index)}"
  skip_destroy = "true"
}
