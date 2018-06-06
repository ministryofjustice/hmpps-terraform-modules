resource "aws_iam_role" "environment" {
  name               = "${var.rolename}-role"
  assume_role_policy = "${file("${var.policyfile}")}"
}
