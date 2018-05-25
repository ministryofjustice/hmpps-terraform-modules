resource "aws_internet_gateway" "environment" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name          = "tf-${var.business_unit}-${var.project}-${var.environment}-igw"
    Project       = "${var.project}"
    Environment   = "${var.environment}"
    Business-Unit = "${var.business_unit}"
  }
}
