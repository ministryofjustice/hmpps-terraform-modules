output "peer_id" {
   value = "${aws_vpc_peering_connection.environment.id}"
}

output "peer_accept_status" {
   value = "${aws_vpc_peering_connection.environment.accept_status}"
}
