
output "bastion_client_sg_id" {
  value = "${aws_security_group.bastion_client_security_group.id}"
}

output "bastion_elb_sg_id" {
  value = "${aws_security_group.bastion_elb_security_group.id}"
}

output "jumphost_dns" {
  value = "${aws_route53_record.jumphost_dns_entry.fqdn}"
}

output "bastion_dns" {
  value = "${aws_route53_record.bastion_dns_entry.fqdn}"
}
