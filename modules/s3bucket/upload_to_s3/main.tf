resource "aws_s3_bucket_object" "environment" {
  key     = var.keyname
  bucket  = var.s3_bucket_name
  content = file(var.filename)
  acl     = var.acl
}

