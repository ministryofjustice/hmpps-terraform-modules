output "elastic_search_backup_bucket_name" {
  value = "${aws_s3_bucket.elasticsearch_backup_bucket.bucket}"
}

output "elastic_search_backup_bucket_id" {
  value = "${aws_s3_bucket.elasticsearch_backup_bucket.id}"
}

output "elastic_search_backup_bucket_arn" {
  value = "${aws_s3_bucket.elasticsearch_backup_bucket.arn}"
}
