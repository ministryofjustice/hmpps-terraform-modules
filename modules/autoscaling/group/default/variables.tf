variable "subnet_ids" {
  type = "list"
}

variable "asg_min" {}
variable "asg_max" {}
variable "asg_desired" {}
variable "launch_configuration" {}
variable "asg_name" {}

variable "tags" {
  type = "map"
}
