resource "aws_route" "environment" {
  count                   = "${length(var.route_table_id)}"
  route_table_id          = "${element(var.route_table_id,count.index)}"
  destination_cidr_block  = "${var.destination_cidr_block}"
  instance_id             = "${var.instance_id}"
}
