# # SECURITY GROUPS
# output "service_alfresco_ecs_cluster_public_nginx_sg_external_lb_id" {
#   value = "${aws_security_group.external_lb_sg.id}"
# }
# output "service_alfresco_security_groups_sg_external_instance_id" {
#   value = "${aws_security_group.external_instance.id}"
# }
# # LB
output "lb_id" {
  value = "${module.create_app_alb.lb_id}"
}

output "lb_arn" {
  value = "${module.create_app_alb.lb_arn}"
}

output "lb_arn_suffix" {
  value = "${module.create_app_alb.lb_arn_suffix}"
}

output "lb_dns_name" {
  value = "${module.create_app_alb.lb_dns_name}"
}

output "lb_dns_alias" {
  value = "${aws_route53_record.dns_entry.fqdn}"
}

# LISTENER
output "https_lb_listener_id" {
  value = "${element(module.create_app_alb_listener.listener_id,0)}"
}

output "https_lb_listener_arn" {
  value = "${element(module.create_app_alb_listener.listener_arn,0)}"
}

output "http_lb_listener_id" {
  value = "${element(module.create_app_alb_listener.listener_id,0)}"
}

output "http_lb_listener_arn" {
  value = "${element(module.create_app_alb_listener.listener_arn,0)}"
}

# TARGET GROUPS
output "target_group_id" {
  value = "${module.create_app_alb_targetgrp.target_group_id}"
}

output "target_group_arn" {
  value = "${module.create_app_alb_targetgrp.target_group_arn}"
}

output "target_group_arn_suffix" {
  value = "${module.create_app_alb_targetgrp.target_group_arn_suffix}"
}

output "target_group_name" {
  value = "${module.create_app_alb_targetgrp.target_group_name}"
}

# ECS CLUSTER
output "ecs_cluster_arn" {
  value = "${module.ecs_cluster.ecs_cluster_arn}"
}

output "ecs_cluster_id" {
  value = "${module.ecs_cluster.ecs_cluster_id}"
}

output "ecs_cluster_name" {
  value = "${module.ecs_cluster.ecs_cluster_name}"
}

# LOG GROUPS
output "loggroup_arn" {
  value = "${module.create_loggroup.loggroup_arn}"
}

output "loggroup_name" {
  value = "${module.create_loggroup.loggroup_name}"
}

# TASK DEFINITION
output "task_definition_arn" {
  value = "${module.app_task_definition.task_definition_arn}"
}

output "task_definition_family" {
  value = "${module.app_task_definition.task_definition_family}"
}

output "task_definition_revision" {
  value = "${module.app_task_definition.task_definition_revision}"
}

# ECS SERVICE
output "ecs_service_id" {
  value = "${module.app_service.ecs_service_id}"
}

output "ecs_service_name" {
  value = "${module.app_service.ecs_service_name}"
}

output "ecs_service_cluster" {
  value = "${module.app_service.ecs_service_cluster}"
}

# Launch config
output "launch_id" {
  value = "${module.launch_cfg.launch_id}"
}

output "launch_name" {
  value = "${module.launch_cfg.launch_name}"
}

# ASG
output "autoscale_id" {
  value = "${module.auto_scale.autoscale_id}"
}

output "autoscale_arn" {
  value = "${module.auto_scale.autoscale_arn}"
}

output "autoscale_name" {
  value = "${module.auto_scale.autoscale_name}"
}
