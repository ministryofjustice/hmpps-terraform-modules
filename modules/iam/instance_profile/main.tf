resource "aws_iam_instance_profile" "environment" {
  name = "tf-${var.region}-terraform-${var.business_unit}-${var.project}-${var.environment}-${var.name}-instance-profile"
  role = "${var.role}"
}
