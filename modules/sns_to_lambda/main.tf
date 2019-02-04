resource "aws_sns_topic" "lambda_sns_topic" {
  name = "${var.sns_identifier}-lambda-sns-topic"
}

resource "aws_sns_topic_subscription" "lambda_sns_subscriber" {
  topic_arn = "${aws_sns_topic.lambda_sns_topic.arn}"
  protocol = "lambda"
  endpoint = "${var.lambda_function_arn}"
}

resource "aws_iam_policy" "lambda_sns_iam_policy" {
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "sns:ListSubscriptionsByTopic",
                "sns:GetTopicAttributes",
                "sns:ListTopics",
                "sns:GetPlatformApplicationAttributes",
                "sns:ListSubscriptions",
                "sns:GetSubscriptionAttributes",
                "logs:PutLogEvents",
                "sns:CheckIfPhoneNumberIsOptedOut",
                "sns:ListEndpointsByPlatformApplication",
                "sns:ListPhoneNumbersOptedOut",
                "sns:GetEndpointAttributes",
                "logs:CreateLogStream",
                "route53:*",
                "sns:ListPlatformApplications",
                "sns:GetSMSAttributes"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "lamda_sns_iam_role_policy" {
  policy = "${aws_iam_policy.lambda_sns_iam_policy.id}"
  role = "${aws_iam_role.lambda_sns_iam_role.id}"
}

resource "aws_iam_role" "lambda_sns_iam_role" {
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "sns.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
EOF
}