variable "region" {
  description = "The AWS region."
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "environment_identifier" {
  description = "resource label or name"
}

variable "short_environment_identifier" {
  description = "short resource label or name"
}

variable "tags" {
  type = "map"
}

variable "availability_zone" {
  type = "map"
}

variable "instance_type" {
  default = "t2.small"
}

variable "nfs_volume_size" {
  default = "80"
}

variable "nfs_encrypted" {
  default = true
}

variable "ec2_policy_file" {}
variable "ec2_role_policy_file" {}

variable "private-cidr" {
  type = "map"
}

variable "nfs_share" {}

variable "ebs_device" {}

variable "bastion_inventory" {}

variable "volume_count" {
  default = "3"
}

variable "route53_sub_domain" {}
