resource "aws_s3_bucket" "environment" {
  bucket = "${var.s3_bucket_name}-s3bucket"
  acl    = "${var.acl}"

  versioning {
    enabled = var.versioning
  }

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${var.kms_master_key_id}"
        sse_algorithm     = "${var.sse_algorithm}"
      }
    }
  }

  tags = "${merge(var.tags, map("Name", "${var.s3_bucket_name}-s3-bucket"))}"
}
