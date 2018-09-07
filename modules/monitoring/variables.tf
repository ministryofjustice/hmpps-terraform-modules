variable "region" {
  description = "The AWS region."
}

variable "environment_identifier" {
  description = "resource label or name"
}

variable "tags" {
  type = "map"
  description = "Tags to identify resources"
}

variable "availability_zones" {
  type = "map"
  description = "a map of az's we can deploy to"
}

variable "remote_state_bucket_name" {}

variable "app_name" {}

variable "policy_file" {}

variable "role_policy_file" {}

variable "elasticsearch_root_directory" {}

variable "ebs_device_mount_point" {}

variable "ebs_device_volume_size" {}

variable "docker_registry_url" {}

variable "docker_image_tag" {}

variable "instance_type" {}

variable "route53_sub_domain" {}

variable "short_environment_identifier" {
  description = "short resource label or name"
}

variable "bastion_client_sg_id" {
  description = "SG to allow ssh access, to come from the shared vpc bastion"
}

variable "allowed_ssh_cidr" {
  type = "list"
}

variable "route53_domain_private" {}

variable "route53_hosted_zone_id" {}

variable "public_ssl_arn" {}