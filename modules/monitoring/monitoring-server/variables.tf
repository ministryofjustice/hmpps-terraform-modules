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

variable "short_environment_identifier" {
  description = "short resource label or name"
}

variable "bastion_client_sg_id" {
  description = "SG to allow ssh access, to come from the shared vpc bastion"
}

variable "app_name" {}

variable "route53_domain_private" {}

variable "route53_sub_domain" {}

variable "whitelist_monitoring_ips" {
  type = "list"
}

variable "route53_hosted_zone_id" {}

variable "elasticsearch_cluster" {}

variable "instance_type" {}

variable "ebs_device_volume_size" {}

variable "docker_image_tag" {}

variable "public_ssl_arn" {}