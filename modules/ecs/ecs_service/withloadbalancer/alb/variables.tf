variable "servicename" {}
variable "clustername" {}

variable "task_definition_family" {}
variable "task_definition_revision" {}
variable "service_desired_count" {}
variable "ecs_service_role" {}
variable "target_group_arn" {}
variable "containername" {}
variable "containerport" {}

variable "deployment_minimum_healthy_percent" {
  default = "50"
}

variable "current_task_definition_version" {}
