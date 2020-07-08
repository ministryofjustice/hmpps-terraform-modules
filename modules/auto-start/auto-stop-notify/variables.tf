variable "name" {
  description = "Lambda function name"
}

variable "cloudwatch_schedule_expression" {
  description = "Define the aws cloudwatch event rule schedule expression"
}

variable "event_rule_enabled" {
  description = "Whether the rule should be enabled"
}

variable "channel" {
  description = "Slack channel to send notification"
}

variable "url_path" {
  description = "Slack url path"
}

variable "tagged_user" {
  description = "Users to be tagged in alerts"
}

