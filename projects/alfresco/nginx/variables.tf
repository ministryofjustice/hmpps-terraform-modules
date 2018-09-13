variable "region" {}

variable "environment_identifier" {}

variable "short_environment_identifier" {}

variable "environment" {}

variable "tags" {
  type = "map"
}

variable "app_hostnames" {
  type = "map"
}

variable "certificate_arn" {
  type = "list"
}

variable "app_name" {}

variable "public_subnet_ids" {
  type = "list"
}

variable "instance_security_groups" {
  type = "list"
}

variable "lb_security_groups" {
  type = "list"
}

variable "config_bucket" {}

variable "vpc_id" {}

variable "access_logs_bucket" {}

variable "external_domain" {}

variable "public_zone_id" {}

variable "cloudwatch_log_retention" {}

variable "alb_http_port" {}

variable "alb_https_port" {}

# variable "alfresco_allowed_ip_cidrs" {
#   type = "list"
# }

# variable "internet_zone_label" {
#   description = "public or private"
# }

################ LB SECTION ###############
variable "alb_backend_port" {}

variable "alb_listener_protocol" {
  default = "HTTPS"
}

variable "public_ssl_policy" {
  default = "ELBSecurityPolicy-FS-2018-06"
}

variable "backend_app_port" {}

variable "backend_app_protocol" {}

variable "backend_app_template_file" {}

variable "backend_check_app_path" {}

variable "backend_check_interval" {}

variable "backend_ecs_cpu_units" {}

variable "backend_ecs_desired_count" {}

variable "backend_ecs_memory" {}

variable "backend_healthy_threshold" {}

variable "backend_maxConnections" {}

variable "backend_maxConnectionsPerRoute" {}

variable "backend_return_code" {}

variable "backend_timeout" {}

variable "backend_timeoutInSeconds" {}

variable "backend_timeoutRetries" {}

variable "backend_unhealthy_threshold" {}

variable "deregistration_delay" {}
variable "target_type" {}

############### END OF LB SECTION #####################

##################### ASG SECTION #####################
variable "service_desired_count" {}

variable "user_data" {}

variable "ebs_device_name" {}
variable "ebs_volume_type" {}
variable "ebs_volume_size" {}
variable "ebs_encrypted" {}

variable "instance_type" {}

variable "volume_size" {}

variable "asg_desired" {}

variable "asg_max" {}

variable "asg_min" {}

variable "associate_public_ip_address" {}

variable "keys_dir" {}

variable "self_signed_ssm" {
  type = "map"
}

############### END OF ASG SECTION #####################

##################### ECS SECTION #####################

variable "image_url" {}

variable "image_version" {}

# variable "alfresco_app_name" {}

variable "kibana_host" {}

variable "ecs_service_role" {}

variable "ami_id" {}

variable "instance_profile" {}

variable "ssh_deployer_key" {}
