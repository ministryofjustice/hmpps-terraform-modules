resource "aws_sns_topic" "lambda_sns_topic" {
  name = "${var.sns_identifier}-lambda-sns-topic"
}

resource "aws_sns_topic_subscription" "lambda_sns_subscriber" {
  topic_arn = "${aws_sns_topic.lambda_sns_topic.arn}"
  protocol = "lambda"
  endpoint = "${var.lambda_function_arn}"
}

resource "aws_iam_policy" "lambda_sns_iam_policy" {
  policy = "${file("policies/allow_sns_policy.json")}"
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
      "Sid": "*"
    }
  ]
}
EOF
}