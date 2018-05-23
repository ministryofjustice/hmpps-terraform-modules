resource "aws_dynamodb_table" "table" {
    name = "${var.dynamotable_name}"
    read_capacity = "${var.read_capacity}"
    write_capacity = "${var.write_capacity}"
    hash_key = "${var.hash_key}"
    attribute {
      name = "${var.hash_key}"
      type = "S"
    }
    tags {
      Name        = "${var.dynamotable_name}"
      Application = "tf-${var.project}-${var.environment}-${var.app_name}"
      Project     =  "${var.project}"
      Environment = "${var.environment}"
    }
}
