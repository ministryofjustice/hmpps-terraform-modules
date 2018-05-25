resource "aws_eip" "environment" {
  count = "${length(var.subnets)}"
  vpc   = true

  tags {
    Name          = "tf-${var.region}-${var.business_unit}-${var.project}-${var.environment}-nat-gateway-eip"
    Project       = "${var.project}"
    Environment   = "${var.environment}"
    Business-Unit = "${var.business_unit}"
  }
}

resource "aws_nat_gateway" "environment" {
  count         = "${length(var.subnets)}"
  allocation_id = "${element(aws_eip.environment.*.id, count.index)}"
  subnet_id     = "${element(var.subnets, count.index)}"

  tags {
    Name          = "tf-${var.region}-${var.business_unit}-${var.project}-${var.environment}-nat-gateway"
    Project       = "${var.project}"
    Environment   = "${var.environment}"
    Business-Unit = "${var.business_unit}"
  }
}
