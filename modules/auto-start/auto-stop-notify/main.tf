### SNS

locals {
  auto_stop_notification   = "auto-stop-notification"
  lambda_name              = "${var.name}-${local.auto_stop_notification}"
}

resource "aws_sns_topic" "auto-stop-notification" {
  name               = "${local.lambda_name}"
}

resource "aws_sns_topic_subscription" "auto-stop-notification" {
  topic_arn          = "${aws_sns_topic.auto-stop-notification.arn}"
  protocol           = "lambda"
  endpoint           = "${aws_lambda_function.auto-stop-notification.arn}"
}

### Lambda
data "archive_file" "auto-stop-notification" {
  type               = "zip"
  source_file        = "${path.module}/lambda/${local.auto_stop_notification}.js"
  output_path        = "${path.module}/files/${local.auto_stop_notification}.zip"
}

data "aws_iam_role" "auto-stop-notification-role" {
  name = "lambda_exec_role"
}

resource "aws_lambda_function" "auto-stop-notification" {
  filename           = "${data.archive_file.auto-stop-notification.output_path}"
  function_name      = "${local.lambda_name}"
  role               = "${data.aws_iam_role.auto-stop-notification-role.arn}"
  handler            = "${local.auto_stop_notification}.handler"
  source_code_hash   = "${base64sha256(file("${data.archive_file.auto-stop-notification.output_path}"))}"
  runtime            = "nodejs12.x"

  environment {
    variables = {
      ENVIRONMENT_TYPE  = "${var.name}"
    }
  }
}


################################################
#
#            CLOUDWATCH EVENT
#
################################################

resource "aws_cloudwatch_event_rule" "auto-stop-notification" {
  name                = "${var.name}-auto-stop-notification-event-rule"
  description         = "Daily Auto Stop Notification"
  schedule_expression = "${var.cloudwatch_schedule_expression}"
  is_enabled          = "${var.event_rule_enabled}"
}

resource "aws_cloudwatch_event_target" "auto-stop-notification" {
  arn  = "${aws_lambda_function.auto-stop-notification.arn}"
  rule = "${aws_cloudwatch_event_rule.auto-stop-notification.name}"
}

resource "aws_lambda_permission" "auto-stop-notification" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  function_name = "${aws_lambda_function.auto-stop-notification.function_name}"
  source_arn    = "${aws_cloudwatch_event_rule.auto-stop-notification.arn}"
}
