variable "fqdn" {
  type = "string"
}

variable "zone_id" {
  type = "string"
}

variable "asg_name" {
  type = "string"
}

variable "asg_instance_launch_count" {
  type = "string"
  default = 0
}

variable "asg_instance_terminating_count" {
  type = "string"
  default = 0
}

variable "private_dns" {
  type = "string"
}

variable "sns_notifcaftion_arn" {
  type = "string"
}

variable "sns_role_arn" {
  type = "string"
}