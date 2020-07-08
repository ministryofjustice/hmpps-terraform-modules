resource "aws_flow_log" "environment" {
  log_destination = var.cloudwatch_loggroup_name
  iam_role_arn    = var.role_arn
  vpc_id          = var.vpc_id
  traffic_type    = "ALL"
}

