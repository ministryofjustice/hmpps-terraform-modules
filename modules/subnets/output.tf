output "subnetid" {
  value = "${aws_subnet.environment.id}"
}

output "subnet_cidr" {
  value = "${aws_subnet.environment.cidr_block}"
}

output "routetableid" {
  value = "${aws_route_table.environment.id}"
}

output "availability_zone" {
  value = "${aws_subnet.environment.availability_zone}"
}
