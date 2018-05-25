# route propagation
resource "aws_vpn_gateway_route_propagation" "environment" {
  count          = "${length(var.route_table_id)}"
  vpn_gateway_id = "${var.vpn_gateway_id}"
  route_table_id = "${element(var.route_table_id,count.index)}"
}
