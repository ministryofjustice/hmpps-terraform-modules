resource "aws_dynamodb_table" "table" {
  name           = "tf-${var.prefix}-lock-table"
  read_capacity  = "${var.read_capacity}"
  write_capacity = "${var.write_capacity}"
  hash_key       = "${var.hash_key}"

  attribute {
    name = "${var.hash_key}"
    type = "S"
  }

  tags {
    Name        = "tf-${var.prefix}-lock-table"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}
