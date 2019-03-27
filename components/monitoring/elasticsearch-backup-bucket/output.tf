output "elastic_search_backup_bucket_name" {
  value = "${aws_s3_bucket.elasticsearch_backup_bucket.bucket}"
}

output "elastic_search_backup_bucket_id" {
  value = "${aws_s3_bucket.elasticsearch_backup_bucket.id}"
}

output "elastic_search_backup_bucket_arn" {
  value = "${aws_s3_bucket.elasticsearch_backup_bucket.arn}"
}

output "elastic_search_backup_bucket_kms_key_id" {
  value = "${aws_kms_key.s3_bucket_encryption_key.id}"
}

output "elastic_search_backup_bucket_kms_key_arn" {
  value = "${aws_kms_key.s3_bucket_encryption_key.arn}"
}

