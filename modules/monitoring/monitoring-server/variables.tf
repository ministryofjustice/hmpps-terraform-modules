variable "region" {
  description = "The AWS region."
}


variable "environment_identifier" {
  description = "resource label or name"
}

variable "availability_zones" {
  type = "list"
  description = "a map of az's we can deploy to"
}


variable "amazon_ami_id" {}

variable "short_environment_identifier" {
  description = "short resource label or name"
}

variable "bastion_origin_cidr" {
  description = "CIDR to allow ssh access, to come from the shared vpc bastion"
}

variable "app_name" {}

variable "route53_domain_private" {}

variable "route53_sub_domain" {}

variable "whitelist_monitoring_ips" {
  type = "list"
}

variable "route53_hosted_zone_id" {}

variable "elasticsearch_cluster_name" {}

variable "elasticsearch_cluster_sg_client_id" {}

variable "instance_type" {}

variable "ebs_device_volume_size" {}

variable "docker_image_tag" {}

variable "private_zone_name" {}

variable "account_id" {}

variable "subnet_ids" {
  type = "list"
}

variable "public_subnet_ids" {
  type = "list"
}

variable "tags" {
  type = "map"
}

variable "vpc_id" {}

variable "vpc_cidr" {}

variable "private_zone_id" {}

variable "public_ssl_arn" {}

variable "ssh_deployer_key" {}

variable "s3-config-bucket" {}

variable "bastion_origin_sgs" {
  type = "list"
}

variable "bastion_inventory" {
  description = "Bastion environment inventory"
  type        = "string"
}
