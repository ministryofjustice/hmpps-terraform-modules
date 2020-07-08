variable "subnet_ids" {
  type = list(string)
}

variable "asg_min" {
}

variable "asg_max" {
}

variable "asg_desired" {
}

variable "launch_configuration" {
}

variable "asg_name" {
}

variable "load_balancers" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

