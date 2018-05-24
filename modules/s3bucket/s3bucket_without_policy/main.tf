resource "aws_s3_bucket" "environment" {
  bucket = "tf-${var.region}-terraform-${var.business_unit}-${var.project}-${var.environment}-${var.s3_bucket_name}"
  acl    = "${var.acl}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  tags {
    Name          = "tf-${var.region}-terraform-${var.business_unit}-${var.project}-${var.environment}-${var.s3_bucket_name}"
    Project       = "${var.project}"
    Environment   = "${var.environment}"
    Business-Unit = "${var.business_unit}"
  }
}
