output "elasticsearch_instance_internal_dns" {
  value = "${aws_route53_record.internal_elasticsearch_dns.fqdn}"
}

output "elasticsearch_instance_private_ip" {
  value = "${module.create_elasticsearch_instance.private_ip}"
}

output "elasticsearch_instance_name" {
  value = "elasticsearch-${var.instance_id}"
}
