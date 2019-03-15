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

variable "remote_state_bucket_name" {}

variable "environment_type" {}

variable "project_name" {}

variable "route53_sub_domain" {}

variable "short_environment_identifier" {
  description = "short resource label or name"
}

variable "whitelist_monitoring_ips" {
  type = "list"
}

variable "route53_domain_private" {}

variable "route53_hosted_zone_id" {}

variable "public_ssl_arn" {}

variable "monitoring_node_count" {
     default = "1"
}

variable "docker_image_tag" {
    default = "latest"
}

variable "docker_es_image_name" {
    default = "hmpps-elasticsearch"
    description = "Used when we want to provision an ES version other than 6.x"
}

variable "tags" {}

variable "efs_mount_dir" {
  default = "/opt/esbackup"
}