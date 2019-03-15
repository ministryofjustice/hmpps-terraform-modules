resource "aws_s3_bucket" "elasticsearch_backup_bucket" {
  bucket  = "${var.bucket_name}"
  acl     = "${var.acl}"

  tags    = "${var.tags}"
}

resource "aws_s3_bucket_policy" "elasticsearch_backup_bucket_policy" {
  bucket = "${aws_s3_bucket.elasticsearch_backup_bucket.bucket}"
  policy = ""
}

data "template_file" "elasticsearch_backup_policy" {
  template = ""
}
