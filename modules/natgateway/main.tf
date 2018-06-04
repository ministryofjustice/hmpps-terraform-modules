resource "aws_eip" "environment" {
  vpc = true

  tags {
    Name          = "tf-${var.az}-nat-gateway-eip"
    Project       = "${var.project}"
    Environment   = "${var.environment}"
    Business-Unit = "${var.business_unit}"
  }
}

resource "aws_nat_gateway" "environment" {
  allocation_id = "${aws_eip.environment.id}"
  subnet_id     = "${var.subnet}"

  tags {
    Name          = "tf-${var.az}-nat-gateway"
    Project       = "${var.project}"
    Environment   = "${var.environment}"
    Business-Unit = "${var.business_unit}"
  }
}
