data "aws_region" "current" {}


################################################
#
#            IAM CONFIGURATION
#
################################################

resource "aws_iam_role" "scheduler" {
  name        = "${var.name}-scheduler-lambda"
  description = "Allows Lambda functions to stop and start ec2 and rds resources"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "schedule_autoscaling" {
  name  = "${var.name}-autoscaling-custom-policy-scheduler"
  role  = "${aws_iam_role.scheduler.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "autoscaling:DescribeScalingProcessTypes",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeTags",
                "autoscaling:SuspendProcesses",
                "autoscaling:ResumeProcesses",
                "autoscaling:UpdateAutoScalingGroup",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:TerminateInstances"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "schedule_spot" {
  name  = "${var.name}-spot-custom-policy-scheduler"
  role  = "${aws_iam_role.scheduler.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ec2:TerminateSpotInstances"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "schedule_ec2" {
  name  = "${var.name}-ec2-custom-policy-scheduler"
  role  = "${aws_iam_role.scheduler.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:StopInstances",
                "ec2:StartInstances",
                "ec2:DescribeTags",
                "ec2:TerminateSpotInstances"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "schedule_rds" {
  name  = "${var.name}-rds-custom-policy-scheduler"
  role  = "${aws_iam_role.scheduler.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "rds:ListTagsForResource",
                "rds:DescribeDBClusters",
                "rds:StartDBCluster",
                "rds:StopDBCluster",
                "rds:DescribeDBInstances",
                "rds:StartDBInstance",
                "rds:StopDBInstance"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_logging" {
  name  = "${var.name}-lambda-logging"
  role  = "${aws_iam_role.scheduler.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:CreateLogStream",
                "logs:CreateLogGroup",
                "logs:PutLogEvents"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

################################################
#
#            LAMBDA FUNCTION
#
################################################

# Convert *.py to .zip because AWS Lambda need .zip
data "archive_file" "scheduler" {
  type        = "zip"
  source_dir  = "${path.module}/package/"
  output_path = "${path.module}/aws-stop-start-resources.zip"
}

# Create Lambda function for stop or start aws resources
resource "aws_lambda_function" "scheduler" {
  filename         = "${data.archive_file.scheduler.output_path}"
  function_name    = "${var.name}"
  role             = "${aws_iam_role.scheduler.arn}"
  handler          = "scheduler.main.lambda_handler"
  source_code_hash = "${data.archive_file.scheduler.output_base64sha256}"
  runtime          = "python3.7"
  timeout          = "600"

  environment {
    variables = {
      AWS_REGIONS          = "${var.aws_regions}"
      SCHEDULE_ACTION      = "${var.schedule_action}"
      TAG_KEY              = "${var.resources_tag["key"]}"
      TAG_VALUE            = "${var.resources_tag["value"]}"
      EC2_SCHEDULE         = "${var.ec2_schedule}"
      RDS_SCHEDULE         = "${var.rds_schedule}"
      AUTOSCALING_SCHEDULE = "${var.autoscaling_schedule}"
      SPOT_SCHEDULE        = "${var.spot_schedule}"
    }
  }
}

################################################
#
#            CLOUDWATCH EVENT
#
################################################

resource "aws_cloudwatch_event_rule" "scheduler" {
  name                = "${var.name}-trigger-lambda-scheduler"
  description         = "Daily Auto Start/Stop of EC2 Instances"
  schedule_expression = "${var.cloudwatch_schedule_expression}"
  is_enabled          = "${var.event_rule_enabled}"
}

resource "aws_cloudwatch_event_target" "scheduler" {
  arn  = "${aws_lambda_function.scheduler.arn}"
  rule = "${aws_cloudwatch_event_rule.scheduler.name}"
}

resource "aws_lambda_permission" "scheduler" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  function_name = "${aws_lambda_function.scheduler.function_name}"
  source_arn    = "${aws_cloudwatch_event_rule.scheduler.arn}"
}

################################################
#
#            CLOUDWATCH LOG
#
################################################

resource "aws_cloudwatch_log_group" "scheduler" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = 14
}
