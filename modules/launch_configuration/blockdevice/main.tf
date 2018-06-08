resource "aws_launch_configuration" "environment" {
  name                        = "${var.launch_configuration_name}-launch-cfg"
  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${var.instance_profile}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${var.security_groups}"]
  associate_public_ip_address = "${var.associate_public_ip_address}"
  user_data                   = "${var.user_data}"
  enable_monitoring           = "${var.enable_monitoring}"
  ebs_optimized               = "${var.ebs_optimized}"

  root_block_device {
    volume_type = "${var.volume_type}"
    volume_size = "${var.volume_size}"
  }

  lifecycle {
    create_before_destroy = true
  }

  ebs_block_device {
    device_name = "${var.ebs_device_name}"
    volume_type = "${var.ebs_volume_type}"
    volume_size = "${var.ebs_volume_size}"
    encrypted   = "${var.ebs_encrypted}"
  }
}
