resource "aws_iam_role_policy" "environment" {
  name   = "tf-${var.region}-terraform-${var.business_unit}-${var.project}-${var.environment}-${var.policyname}"
  role   = "${var.rolename}"
  policy = "${var.policyfile}"
}
