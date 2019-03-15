output "monitoring_server_internal_url" {
  value = "${module.create_monitoring_instance.monitoring_server_internal_dns}"
}

output "monitoring_server_external_url" {
  value = "${module.create_monitoring_instance.monitoring_server_external_dns}"
}


output "monitoring_server_client_sg_id" {
  value = "${module.create_monitoring_instance.monitoring_server_client_security_group_id}"
}

//output "es_cluster_nodes" {
//  value = ["${module.create_elastic_cluster}"]
//}