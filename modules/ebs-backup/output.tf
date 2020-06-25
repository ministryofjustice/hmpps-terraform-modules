output "aws_iam_role_arn" {
  value = module.ebs_backup_iam_role.iamrole_arn
}

output "backup_lambda_function_name" {
  value = aws_lambda_function.ebs_backup_lambda.function_name
}

output "prune_lambda_function_name" {
  value = aws_lambda_function.ebs_prune_lambda.function_name
}

