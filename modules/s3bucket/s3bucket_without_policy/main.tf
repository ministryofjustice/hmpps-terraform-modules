resource "aws_s3_bucket" "environment" {
  bucket = "tf-${var.s3_bucket_name}-s3bucket"
  acl    = "${var.acl}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  tags {
    Name          = "tf-${var.s3_bucket_name}-s3-bucket"
    Project       = "${var.project}"
    Environment   = "${var.environment}"
    Business-Unit = "${var.business_unit}"
  }
}
