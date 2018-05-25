resource "aws_iam_policy" "environment" {
  name        = "tf-${var.region}-terraform-${var.business_unit}-${var.project}-${var.environment}-${var.policyname}"
  role        = "${var.rolename}"
  description = "${var.policy_description}"
  policy      = "${file("${var.policyfile}")}"
}
