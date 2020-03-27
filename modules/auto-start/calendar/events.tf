
################################################
#
#            CLOUDWATCH EVENT
#
################################################

resource "aws_cloudwatch_event_rule" "start" {
  name                = "${var.environment_name}-start-ec2"
  description         = "Auto Start of EC2 Instances"
  schedule_expression = "${var.schedule_expression}"
  is_enabled          = "${var.is_enabled}"
}

resource "aws_cloudwatch_event_rule" "stop" {
  name                = "${var.environment_name}-stop-ec2"
  description         = "Auto Stop of EC2 Instances"
  schedule_expression = "${var.schedule_expression}"
  is_enabled          = "${var.is_enabled}"
}

resource "aws_cloudwatch_event_target" "start" {
  arn           = "${replace(local.start_doc_arn, "document/", "automation-definition/")}"
  rule          = "${aws_cloudwatch_event_rule.start.name}"
  role_arn      = "${aws_iam_role.event.arn}"
}

resource "aws_cloudwatch_event_target" "stop" {
  arn           = "${replace(local.stop_doc_arn, "document/", "automation-definition/")}"
  rule          = "${aws_cloudwatch_event_rule.stop.name}"
  role_arn      = "${aws_iam_role.event.arn}"
}
