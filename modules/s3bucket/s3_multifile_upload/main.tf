resource "null_resource" "environment" {

triggers  {
changes_are_there = "${var.changes_are_there}"
}

provisioner "local-exec" {
  when = "create"
  command = "aws s3 sync ${var.folder_to_upload} s3://${var.s3_bucket_name} --acl ${var.acl}"
  on_failure = "fail"
}

#provisioner "local-exec" {
#  when = "destroy"
#  command = "aws s3 rm s3://${var.s3_bucket_name} --recursive"
#  on_failure = "fail"
#}

}
