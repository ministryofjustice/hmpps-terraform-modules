output "bastion_asg_sg_id" {
  value = "${aws_security_group.bastion_asg_security_group.id}"
}

output "bastion_client_sg_id" {
  value = "${aws_security_group.bastion_client_security_group.id}"
}

output "bastion_elb_sg_id" {
  value = "${aws_security_group.bastion_elb_security_group.id}"
}
