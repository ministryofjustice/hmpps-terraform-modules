resource "aws_eip" "environment" {
  vpc  = true
  tags = "${merge(var.tags, map("Name", "${var.az}-nat-gateway"), map("Do-Not-Delete", "true"))}"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_nat_gateway" "environment" {
  allocation_id = "${aws_eip.environment.id}"
  subnet_id     = "${var.subnet}"
  tags          = "${merge(var.tags, map("Name", "${var.az}-nat-gateway"))}"
}
