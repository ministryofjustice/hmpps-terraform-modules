variable "log_group_path" {
  description = "resource label or name"
}

variable "loggroupname" {}

variable "cloudwatch_log_retention" {}

variable "tags" {
  type = "map"
}
