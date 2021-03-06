# ELB
output "asg_elb_id" {
  description = "The name of the ELB"
  value       = "${module.create_app_elb.environment_elb_id}"
}

output "asg_elb_name" {
  description = "The name of the ELB"
  value       = "${module.create_app_elb.environment_elb_name}"
}

output "asg_elb_dns_name" {
  description = "The DNS name of the ELB"
  value       = "${module.create_app_elb.environment_elb_dns_name}"
}

output "asg_elb_instances" {
  description = "The list of instances in the ELB (if may be outdated, because instances are attached using elb_attachment resource)"
  value       = ["${module.create_app_elb.environment_elb_instances}"]
}

output "asg_elb_source_security_group_id" {
  description = "The ID of the security group that you can use as part of your inbound rules for your load balancer's back-end application instances"
  value       = "${module.create_app_elb.environment_elb_source_security_group_id}"
}

output "asg_elb_zone_id" {
  description = "The canonical hosted zone ID of the ELB (to be used in a Route 53 Alias record)"
  value       = "${module.create_app_elb.environment_elb_zone_id}"
}

output "asg_elb_dns_cname" {
  value = "${aws_route53_record.dns_entry.fqdn}"
}

# Launch config
# AZ1
output "asg_launch_id_az1" {
  value = "${module.launch_cfg_az1.launch_id}"
}

output "asg_launch_name_az1" {
  value = "${module.launch_cfg_az1.launch_name}"
}

# AZ2
output "asg_launch_id_az2" {
  value = "${module.launch_cfg_az2.launch_id}"
}

output "asg_launch_name_az2" {
  value = "${module.launch_cfg_az2.launch_name}"
}

# AZ3
output "asg_launch_id_az3" {
  value = "${module.launch_cfg_az3.launch_id}"
}

output "asg_launch_name_az3" {
  value = "${module.launch_cfg_az3.launch_name}"
}

# ASG
#AZ1
output "asg_autoscale_id_az1" {
  value = "${module.auto_scale_az1.autoscale_id}"
}

output "asg_autoscale_arn_az1" {
  value = "${module.auto_scale_az1.autoscale_arn}"
}

output "asg_autoscale_name_az1" {
  value = "${module.auto_scale_az1.autoscale_name}"
}

#AZ2
output "asg_autoscale_id_az2" {
  value = "${module.auto_scale_az2.autoscale_id}"
}

output "asg_autoscale_arn_az2" {
  value = "${module.auto_scale_az2.autoscale_arn}"
}

output "asg_autoscale_name_az2" {
  value = "${module.auto_scale_az2.autoscale_name}"
}

#AZ3
output "asg_autoscale_id_az3" {
  value = "${module.auto_scale_az3.autoscale_id}"
}

output "asg_autoscale_arn_az3" {
  value = "${module.auto_scale_az3.autoscale_arn}"
}

output "asg_autoscale_name_az3" {
  value = "${module.auto_scale_az3.autoscale_name}"
}

# LOG GROUPS
output "asg_loggroup_arn" {
  value = "${module.create_loggroup.loggroup_arn}"
}

output "asg_loggroup_name" {
  value = "${module.create_loggroup.loggroup_name}"
}

# AMI
output "asg_latest_ami" {
  value = "${var.ami_id}"
}
