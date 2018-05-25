output natid {
  value = "${aws_nat_gateway.environment.*.id}"
}
