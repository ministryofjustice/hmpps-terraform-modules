variable "appname" {}
variable "image_id" {}
variable "instance_type" {}
variable "instance_profile" {}
variable "key_name" {}

variable "security_groups" {
  type = "list"
}

variable "associate_public_ip_address" {
  default = "false"
}

variable "user_data" {}

variable "enable_monitoring" {
  default = "true"
}

variable "ebs_optimized" {
  default = "false"
}
