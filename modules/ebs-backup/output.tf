output "aws_iam_role_arn" {
  value = "${module.ebs_backup_iam_role.iamrole_arn}"
}

output "lambda_function_name" {
  value = "${aws_lambda_function.ebs_backup_lambda.function_name}"
}