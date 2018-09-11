# SECURITY GROUPS

output "security_groups_sg_internal_lb_id" {
  value = "${aws_security_group.internal_lb_sg.id}"
}

output "security_groups_sg_internal_instance_id" {
  value = "${aws_security_group.internal_instance.id}"
}

output "security_groups_sg_rds_id" {
  value = "${aws_security_group.rds_sg.id}"
}
