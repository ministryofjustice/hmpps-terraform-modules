variable "region" {
  description = "The AWS region."
}


variable "environment_identifier" {
  description = "resource label or name"
}

variable "availability_zones" {
  type = "map"
  description = "a map of az's we can deploy to"
}

variable "terraform_remote_state_vpc" {
  type = "map"
}

variable "amazon_ami_id" {}

variable "app_name" {}

variable "ebs_device_volume_size" {}

variable "docker_image_tag" {}

variable "instance_type" {}

variable "route53_sub_domain" {}

variable "short_environment_identifier" {
  description = "short resource label or name"
}

variable "bastion_client_sg_id" {
  description = "SG to allow ssh access, to come from the shared vpc bastion"
}