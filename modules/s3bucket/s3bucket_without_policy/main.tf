resource "aws_s3_bucket" "environment" {
  bucket = "${var.s3_bucket_name}-s3bucket"
  acl    = "${var.acl}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  tags          = "${merge(var.tags, map("name", "${var.s3_bucket_name}-s3-bucket"))}"
}
