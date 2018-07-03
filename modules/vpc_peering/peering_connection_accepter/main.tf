data "aws_caller_identity" "peer" {
  provider = "aws.peer"
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = "aws.peer"
  count                     = "${var.create == "true" ? 1 : 0}"
  vpc_peering_connection_id = "${var.vpc_peering_connection_id}"
  auto_accept               = "${var.auto_accept}"

  tags = "${merge(var.tags, map("Name", "${var.peering_connection_name}-peer-connection"))}"
}
