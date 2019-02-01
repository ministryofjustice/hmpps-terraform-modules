output "lambda_sns_topic_id" {
  value = "${aws_sns_topic.lambda_sns_topic.id}"
}

output "lambda_sns_topic_name" {
  value = "${aws_sns_topic.lambda_sns_topic.name}"
}

output "lambda_sns_topic_arn" {
  value = "${aws_sns_topic.lambda_sns_topic.arn}"
}

output "lambda_sns_topic_subscription_arn" {
  value = "${aws_sns_topic_subscription.lambda_sns_subscriber.arn}"
}

output "lambda_sns_iam_role_arn" {
  value = "${aws_iam_role.lambda_sns_iam_role.arn}"
}
