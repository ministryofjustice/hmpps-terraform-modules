resource "aws_iam_role" "environment" {
  name               = "tf-${var.region}-terraform-${var.business_unit}-${var.project}-${var.environment}-${var.rolename}"
  assume_role_policy = "${file("${var.policyfile}")}"
}
