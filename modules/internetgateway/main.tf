resource "aws_internet_gateway" "environment" {
  vpc_id = "${var.vpc_id}"
  tags   = "${merge(var.tags, map("name", "${var.gateway_name}-internet-gateway"))}"
}
