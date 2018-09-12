# Instance variables

variable "app_name" {}

variable "environment_identifier" {}

variable "ami_id" {}

variable "instance_type" {}

variable "subnet_id" {}

variable "instance_profile" {}

variable "user_data" {}

variable "instance_tags" {
  type = "map"
}

variable "ssh_deployer_key" {}

variable "security_groups" {
  type = "list"
}

# Ebs volume variables
variable "volume_tags" {
  type = "map"
}

variable "volume_availability_zone" {}

variable "volume_size" {}

#Route53
variable "instance_id" {}

variable "zone_name" {}

variable "zone_id" {}

