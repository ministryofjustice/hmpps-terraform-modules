variable "ec2_instance_tag" {
  default     = "Backup"
  description = "Tag to identify the EC2 target instances of the Lambda Function"
}
variable "retention_days" {
  default = 7
  description = "Numbers of Days that the EBS Snapshots will be stored (INT)"
}
variable "unique_name" {
  default = "v1"
  description = "Enter Unique Name to identify the Terraform Stack (lowercase)"
}

variable "stack_prefix" {
  description = "Stack Prefix for resource generation"
}

variable "cron_expression" {
  description = "Cron expression for firing up the Lambda Function"
}

variable "regions" {
  type = "list"
}

variable "rolename_prefix" {
  description = "the name prefix to apply to the role and policy"
}
