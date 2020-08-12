variable "region" {
  description = "The AWS region."
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "environment_identifier" {
  description = "resource label or name"
}

variable "app_name" {
  description = "name for the nfs server"
  default     = "nfs"
}

variable "short_environment_identifier" {
  description = "short resource label or name"
}

variable "tags" {
  type = map(string)
}

variable "availability_zones" {
  type = list(string)
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

variable "ec2_policy_file" {
  default = "ec2_policy.json"
}

variable "ec2_role_policy_file" {
  default = "policies/ec2_role_policy.json"
}

variable "private-cidr" {
  type = list(string)
}

variable "bastion_origin_sgs" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "bastion_inventory" {
  description = "Bastion environment inventory"
  type        = string
  default     = "dev"
}

variable "volume_count" {
  default = "3"
}

variable "route53_sub_domain" {
}

