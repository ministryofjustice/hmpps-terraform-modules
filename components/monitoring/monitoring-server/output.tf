output "monitoring_server_client_security_group_id" {
  value = "${aws_security_group.monitoring_sg.id}"
}

output "monitoring_server_internal_dns" {
  value = "${aws_route53_record.internal_monitoring_dns.fqdn}"
}

output "monitoring_server_external_dns" {
  value = "${aws_route53_record.external_monitoring_dns.fqdn}"
}

output "monitoring_server_internal_ipv4" {
  value = "${module.create_monitoring_server.private_ip}"
}