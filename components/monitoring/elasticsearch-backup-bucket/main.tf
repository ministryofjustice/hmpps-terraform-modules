resource "aws_kms_key" "s3_bucket_encryption_key" {
  description             = "Ensure backups at rest are encrypted"
  deletion_window_in_days = 10
}


resource "aws_s3_bucket" "elasticsearch_backup_bucket" {
  bucket  = "${var.bucket_name}"

  acl     = "${var.acl}"
  tags    = "${var.tags}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.s3_bucket_encryption_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "elasticsearch_backup_bucket_policy" {
  bucket = "${aws_s3_bucket.elasticsearch_backup_bucket.bucket}"
  policy = "${data.template_file.elasticsearch_backup_policy.rendered}"
}

data "template_file" "elasticsearch_backup_policy" {
  template    = "${file("${path.module}/policies/elasticsearch-backup-bucket.json")}"

  vars {
    bucket      = "${var.bucket_name}"
    vpc_cidr    = "${var.vpc_cidr}"
    account_id  = "${var.account_id}"
  }
}

