output "elasticsearch_cluster_sg_client_id" {
  value = "${aws_security_group.elasticsearch_client_sg.id}"
}

output "elasticsearch_1_internal_dns" {
  value = "${module.create_elasticsearch_instance_1.elasticsearch_instance_internal_dns}"
}

output "elasticsearch_1_internal_ipv4" {
  value = "${module.create_elasticsearch_instance_1.elasticsearch_instance_private_ip}"
}

output "elasticsearch_2_internal_dns" {
  value = "${module.create_elasticsearch_instance_2.elasticsearch_instance_internal_dns}"
}

output "elasticsearch_2_internal_ipv4" {
  value = "${module.create_elasticsearch_instance_2.elasticsearch_instance_private_ip}"
}

output "elasticsearch_3_internal_dns" {
  value = "${module.create_elasticsearch_instance_3.elasticsearch_instance_internal_dns}"
}

output "elasticsearch_3_internal_ipv4" {
  value = "${module.create_elasticsearch_instance_3.elasticsearch_instance_private_ip}"
}

output "elasticsearch_cluster_name" {
  value = "${var.short_environment_identifier}-${var.app_name}"
}