output "elasticsearch_internal_dns" {
  value = "${aws_route53_record.internal_elasticsearch_dns.fqdn}"
}

output "elasticsearch_private_ip" {
  value = "${module.create_elasticsearch_instance.private_ip}"
}
