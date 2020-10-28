output "id" {
  value = aws_vpc_peering_connection_accepter.peer.id
}

output "peer_vpc_id" {
  value = aws_vpc_peering_connection_accepter.peer.peer_vpc_id
}

output "accepter" {
  value = aws_vpc_peering_connection_accepter.peer.accepter
}

output "requester " {
  value = aws_vpc_peering_connection_accepter.peer.requester
}
