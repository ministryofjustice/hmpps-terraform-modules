module "ebs_backup_iam_role" {
  source      = "../iam/role"
  policyfile  = "lambda_role.json"
  rolename    = "${var.rolename_prefix}-lambda-role"
}

module "ebs_backup_iam_policy" {
  source = "../iam/rolepolicy"
  policyfile = "${file("${path.module}/policies/lambda_policy.json")}"
  rolename = "${module.ebs_backup_iam_role.iamrole_id}"

}

data "template_file" "vars" {
    template = "${file("${path.module}/files/vars.ini")}"
    vars {
      ec2_instance_tag = "${var.ec2_instance_tag}"
      retention_days   = "${var.retention_days}"
      regions          = "${join(",", var.regions)}"
    }
}

resource "null_resource" "build_ebs_lambdazip" {
  triggers { key = "${format("%s%s%s",
    lower(md5(file("${path.module}/lambda/ebs_backup.py"))),
    lower(md5(file("${path.module}/lambda/clean_old_volumes.py"))),
    lower(md5(file("${path.module}/files/vars.ini"))))}" }
  provisioner "local-exec" {
    command = <<EOF
    cp ${path.module}/lambda/ebs_backup.py ${path.module}/tmp/ebs_backup.py
    cp ${path.module}/lambda/clean_old_volumes.py ${path.module}/tmp/clean_old_volumes.py
    echo "${data.template_file.vars.rendered}" > ${path.module}/tmp/vars.ini
EOF
  }
}

data "archive_file" "ebs_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/tmp"
  output_path = "${path.module}/lambda/${null_resource.build_ebs_lambdazip.id}/${var.stack_prefix}-${var.unique_name}.zip"
}

resource "aws_lambda_function" "ebs_backup_lambda" {
  function_name     = "${var.stack_prefix}_snapshot_${var.unique_name}"
  filename          = "${path.module}/lambda/${null_resource.build_ebs_lambdazip.id}/${var.stack_prefix}-${var.unique_name}.zip"
  source_code_hash  = "${data.archive_file.ebs_lambda_zip.output_base64sha256}"
  role              = "${module.ebs_backup_iam_role.iamrole_arn}"
  runtime           = "python3.6"
  handler           = "ebs_backup.lambda_handler"
  timeout           = "60"
  publish           = true
}

resource "aws_lambda_function" "ebs_prune_lambda" {
  function_name     = "${var.stack_prefix}_prune_${var.unique_name}"
  filename          = "${path.module}/lambda/${null_resource.build_ebs_lambdazip.id}/${var.stack_prefix}-${var.unique_name}.zip"
  source_code_hash  = "${data.archive_file.ebs_lambda_zip.output_base64sha256}"
  role              = "${module.ebs_backup_iam_role.iamrole_arn}"
  runtime           = "python3.6"
  handler           = "clean_old_volumes.lambda_handler"
  timeout           = 300
  memory_size       = 1024
  publish           = true
}

resource "aws_cloudwatch_event_rule" "ebs_backup_timer" {
  name = "${var.stack_prefix}_ebs_backup_event_${var.unique_name}"
  description = "Cronlike scheduled Cloudwatch Event for creating and deleting EBS Snapshots"
  schedule_expression = "cron(${var.cron_expression})"
}

resource "aws_cloudwatch_event_rule" "ebs_prune_backup_timer" {
  name = "${var.stack_prefix}_ebs_prune_event_${var.unique_name}"
  description = "Cronlike scheduled Cloudwatch Event for creating and deleting EBS Snapshots"
  schedule_expression = "cron(${var.cron_expression})"
}

resource "aws_cloudwatch_event_target" "run_ebs_backup_lambda" {
    rule = "${aws_cloudwatch_event_rule.ebs_backup_timer.name}"
    target_id = "${aws_lambda_function.ebs_backup_lambda.id}"
    arn = "${aws_lambda_function.ebs_backup_lambda.arn}"
}

resource "aws_cloudwatch_event_target" "run_ebs_prune_lambda" {
    rule = "${aws_cloudwatch_event_rule.ebs_prune_backup_timer.name}"
    target_id = "${aws_lambda_function.ebs_prune_lambda.id}"
    arn = "${aws_lambda_function.ebs_prune_lambda.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_backup" {
  statement_id = "${var.stack_prefix}_AllowExecutionFromCloudWatch_${var.unique_name}"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.ebs_backup_lambda.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.ebs_backup_timer.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_prune" {
  statement_id = "${var.stack_prefix}_AllowExecutionFromCloudWatch_${var.unique_name}_prune"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.ebs_prune_lambda.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.ebs_prune_backup_timer.arn}"
}
