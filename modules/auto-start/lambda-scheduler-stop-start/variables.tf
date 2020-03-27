variable "cloudwatch_schedule_expression" {
  description = "Define the aws cloudwatch event rule schedule expression"
  type        = "string"
  default     = "cron(0 22 ? * MON-FRI *)"
}

variable "name" {
  description = "Define name to use for lambda function, cloudwatch event and iam role"
  type        = "string"
}

variable "aws_regions" {
  description = "A list of one or more aws regions where the lambda will be apply, default use the current region"
  type        = "string"
  default     = "eu-west-2"
}

variable "schedule_action" {
  description = "Define schedule action to apply on resources, accepted value are 'stop or 'start"
  type        = "string"
  default     = "stop"
}

variable "resources_tag" {
  description = "Set the tag use for identify resources to stop or start"
  type        = "map"

  default = {
    key   = "tostop"
    value = "true"
  }
}

variable "autoscaling_schedule" {
  description = "Enable scheduling on autoscaling resources"
  type        = "string"
  default     = "false"
}

variable "spot_schedule" {
  description = "Enable scheduling on spot instance resources"
  type        = "string"
  default     = "false"
}

variable "ec2_schedule" {
  description = "Enable scheduling on ec2 resources"
  type        = "string"
  default     = "false"
}

variable "rds_schedule" {
  description = "Enable scheduling on rds resources"
  type        = "string"
  default     = "false"
}

variable "event_rule_enabled" {
  description = "Whether the rule should be enabled"
}
