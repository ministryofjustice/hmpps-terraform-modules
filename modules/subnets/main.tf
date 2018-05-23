resource "aws_subnet" "environment" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${var.subnet_cidr_block[count.index]}"
  availability_zone       = "${var.availability_zone}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
  count                   = "${length(var.subnet_cidr_block)}"

  tags {
    Name          = "tf-${var.business_unit}-${var.project}-${var.environment}-${var.subnet_name}-${count.index}-subnet"
    Project       = "${var.project}"
    Environment   = "${var.environment}"
    Business-Unit = "${var.business_unit}"
  }
}

## Route configuration
resource "aws_route_table" "environment" {
  count  = "${length(var.subnet_cidr_block)}"
  vpc_id = "${var.vpc_id}"

  tags {
    Name          = "tf-${var.business_unit}-${var.project}-${var.environment}-${var.subnet_name}-${count.index}-rt"
    Project       = "${var.project}"
    Environment   = "${var.environment}"
    Business-Unit = "${var.business_unit}"
  }
}

## Route Table Association
resource "aws_route_table_association" "environment" {
  count          = "${length(var.subnet_cidr_block)}"
  subnet_id      = "${element(aws_subnet.environment.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.environment.*.id, count.index)}"
}
