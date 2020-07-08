resource "aws_vpc_peering_connection" "environment" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = var.peer_vpc_id
  vpc_id        = var.current_vpc_id
  auto_accept   = var.auto_accept

  accepter {
    allow_remote_vpc_dns_resolution = var.dns_resolution
  }

  requester {
    allow_remote_vpc_dns_resolution = var.dns_resolution
  }

  tags = merge(
    var.tags,
    {
      "Name" = "${var.peering_connection_name}-peer-connection"
    },
  )
}

