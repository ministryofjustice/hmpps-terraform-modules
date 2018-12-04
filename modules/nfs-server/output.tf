output "nfs_client_sg_id" {
  value = "${aws_security_group.nfs_client_sg.id}"
}

output "nfs_host_fqdn" {
  value = "${aws_route53_record.internal_dns.fqdn}"
}

output "nfs_host_private_dns" {
  value = "${module.create-ec2-instance.private_dns}"
}

output "nfs_host_private_ip" {
  value = "${module.create-ec2-instance.private_ip}"
}
