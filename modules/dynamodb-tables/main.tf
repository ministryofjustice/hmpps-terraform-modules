resource "aws_dynamodb_table" "table" {
  name           = "${var.table_name}"
  read_capacity  = "${var.read_capacity}"
  write_capacity = "${var.write_capacity}"
  hash_key       = "${var.hash_key}"

  attribute {
    name = "${var.hash_key}"
    type = "S"
  }
  tags = "${merge(var.tags, map("Name", "${var.table_name}"))}"
}
