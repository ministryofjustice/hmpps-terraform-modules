variable "subnets" {
  type        = "list"
  default     = []
  description = "AWS subnet ids"
}

variable "name" {
  description = "The Name of the application or solution  (e.g. `bastion` or `portal`)"
}
