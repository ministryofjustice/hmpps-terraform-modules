provider "aws" {
  version = "~> 2.65"
}

resource "aws_route" "environment" {
  count                  = length(var.route_table_id)
  route_table_id         = element(var.route_table_id, count.index)
  destination_cidr_block = element(var.destination_cidr_block, count.index)
  gateway_id             = var.gateway_id
}

