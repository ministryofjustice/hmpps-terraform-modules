variable "ami_id" {}

variable "instance_type" {}

variable "subnet_id" {}

variable "iam_instance_profile" {}

variable "associate_public_ip_address" {}

variable "vpc_security_group_ids" {
  type = "list"
}

variable "key_name" {}

variable "CreateSnapshot" {}

variable "user_data" {}

variable "app_name" {}

variable "monitoring" {
  default = true
}

variable "tags" {
  type = "map"
}

variable "root_device_size" {
  default = "8"
}

# whether to deploy an instance of this module
# Allow overriding for diff envs when the code base uses static definitions of the number of ec2 instances to deploy
# and we don't want to replace running instances
variable "deploy" {
  default = true
}