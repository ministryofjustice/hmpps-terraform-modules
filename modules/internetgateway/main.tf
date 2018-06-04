resource "aws_internet_gateway" "environment" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name          = "tf-${var.gateway_name}-internet-gateway"
    Project       = "${var.project}"
    Environment   = "${var.environment}"
    Business-Unit = "${var.business_unit}"
  }
}
