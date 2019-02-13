#TODO: add oracle RDS for OID
data "template_file" "user_data" {
  template = "${file("${path.module}/user_data/user_data.sh")}"

  vars {
    env_identifier       = "${var.environment_identifier}"
    short_env_identifier = "${var.short_environment_identifier}"
    region               = "${var.region}"
    app_name             = "${var.server_name}"
    route53_sub_domain   = "${var.environment_name}"
    private_domain       = "${var.private_domain}"
    account_id           = "${var.vpc_account_id}"
    bastion_inventory    = "${var.bastion_inventory}"

    service_user_name             = "${var.ansible_vars["service_user_name"]}"
    database_global_database_name = "${var.ansible_vars["database_global_database_name"]}"
    database_sid                  = "${var.ansible_vars["database_sid"]}"
    database_characterset         = "${var.ansible_vars["database_characterset"]}"
    database_type                 = "${lookup(var.ansible_vars, "database_type", "NOTSET")}"
    dependencies_bucket_arn       = "${lookup(var.ansible_vars, "dependencies_bucket_arn", "NOTSET")}"
    database_bootstrap_restore    = "${lookup(var.ansible_vars, "database_bootstrap_restore", "False")}"
    database_backup               = "${lookup(var.ansible_vars, "database_backup", "NOTSET")}"
    database_backup_sys_passwd    = "${lookup(var.ansible_vars, "database_backup_sys_passwd", "NOTSET")}"
    database_backup_location      = "${lookup(var.ansible_vars, "database_backup_location", "NOTSET")}"
  }
}

resource "aws_instance" "oracle_db" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${var.db_subnet}"
  key_name               = "${var.key_name}"
  iam_instance_profile   = "${var.iam_instance_profile}"
  source_dest_check      = false
  vpc_security_group_ids = ["${var.security_group_ids}"]
  user_data              = "${data.template_file.user_data.rendered}"

  root_block_device = {
    delete_on_termination = true
    volume_size           = 50
    volume_type           = "gp2"
  }

  tags = "${merge(var.tags, map("Name", "${var.environment_name}-${var.server_name}"))}"

  lifecycle {
    ignore_changes = ["ami", "user_data"]
  }
}

resource "aws_ebs_volume" "oracle_db_xvdd" {
  availability_zone = "${aws_instance.oracle_db.availability_zone}"
  type              = "io1"
  iops              = 1000
  size              = 50
  encrypted         = true
  kms_key_id        = "${var.kms_key_id}"
  tags              = "${merge(var.tags, map("Name", "${var.environment_name}-${var.server_name}-xvdd"))}"
}

resource "aws_volume_attachment" "oracle_db_xvdd" {
  device_name  = "/dev/xvdd"
  instance_id  = "${aws_instance.oracle_db.id}"
  volume_id    = "${aws_ebs_volume.oracle_db_xvdd.id}"
  force_detach = true
}

resource "aws_ebs_volume" "oracle_db_xvde" {
  availability_zone = "${aws_instance.oracle_db.availability_zone}"
  type              = "io1"
  iops              = 1000
  size              = 50
  encrypted         = true
  kms_key_id        = "${var.kms_key_id}"
  tags              = "${merge(var.tags, map("Name", "${var.environment_name}-${var.server_name}-xvde"))}"
}

resource "aws_volume_attachment" "oracle_db_xvde" {
  device_name  = "/dev/xvde"
  instance_id  = "${aws_instance.oracle_db.id}"
  volume_id    = "${aws_ebs_volume.oracle_db_xvde.id}"
  force_detach = true
}

resource "aws_route53_record" "oracle_db_instance_internal" {
  zone_id = "${var.private_zone_id}"
  name    = "${var.server_name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.oracle_db.private_ip}"]
}

resource "aws_route53_record" "oracle_db_instance_public" {
  zone_id = "${var.public_zone_id}"
  name    = "${var.server_name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.oracle_db.private_ip}"]
}
