resource "aws_route" "environment" {
  count                  = "${length(var.route_table_id)}"
  route_table_id         = "${element(var.route_table_id,count.index)}"
  destination_cidr_block = "${element(var.destination_cidr_block,count.index)}"
  nat_gateway_id         = "${element(var.nat_gateway_id,count.index)}"
}
