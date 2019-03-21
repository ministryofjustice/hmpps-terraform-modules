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

variable "app_name" {}

variable "ebs_device_volume_size" {}

variable "docker_image_tag" {}

variable "docker_image_name" {
  default = "hmpps-elasticsearch"
}

variable "instance_type" {}

variable "route53_sub_domain" {}

variable "short_environment_identifier" {
  description = "short resource label or name"
}

variable "bastion_origin_cidr" {
  description = "The origin cidr block from the bastion vpc"
}

# Vpc defined values
variable "private_zone_name" {}

variable "private_zone_id" {}

variable "account_id" {}

variable "tags" {
  type = "map"
}

variable "subnet_ids" {
  type = "list"
}

variable "ssh_deployer_key" {}

variable "vpc_id" {}

variable "vpc_cidr" {}

variable "s3-config-bucket" {}

variable "bastion_origin_sgs" {
  type = "list"
}

variable "bastion_inventory" {
  description = "Bastion environment inventory"
  type        = "string"
}

variable "efs_mount_dir" {}

variable "efs_file_system_id" {}

variable "elasticsearch-backup-bucket" {}

variable "retention_period" {
  description = "How long do we want to keep our indices for"
  default     = 365
}

variable "backup_retention_days" {
  description = "How many days do we want to store the backup on our efs share"
  default     = 14
}
