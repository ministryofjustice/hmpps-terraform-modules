resource "aws_iam_role" "environment" {
  name               = "tf-${var.rolename}-role"
  assume_role_policy = "${file("${var.policyfile}")}"
}
