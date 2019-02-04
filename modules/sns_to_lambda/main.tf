resource "aws_sns_topic" "lambda_sns_topic" {
  name = "${var.sns_identifier}-lambda-sns-topic"
}

resource "aws_sns_topic_subscription" "lambda_sns_subscriber" {
  topic_arn = "${aws_sns_topic.lambda_sns_topic.arn}"
  protocol  = "lambda"
  endpoint  = "${var.lambda_function_arn}"
}
