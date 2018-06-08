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

variable "volume_type" {
  default = "standard"
}

variable "volume_size" {
  default = "10"
}

variable "launch_configuration_name" {
  description = "launch configuration name"
}

variable "ebs_device_name" {}
variable "ebs_volume_type" {}
variable "ebs_volume_size" {}
variable "ebs_encrypted" {}
