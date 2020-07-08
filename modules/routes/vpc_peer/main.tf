resource "aws_route" "environment" {
  count                     = length(var.route_table_id) * var.create ? 1 : 0
  route_table_id            = element(var.route_table_id, count.index)
  destination_cidr_block    = var.destination_cidr_block
  vpc_peering_connection_id = var.vpc_peer_id
}

