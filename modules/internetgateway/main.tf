resource "aws_internet_gateway" "environment" {
  vpc_id = "${var.vpc_id}"
  tags   = "${merge(var.tags, map("Name", "${var.gateway_name}-internet-gateway"))}"
}
