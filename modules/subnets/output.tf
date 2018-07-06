output "subnetid" {
  value = "${aws_subnet.environment.id}"
}

output "routetableid" {
  value = "${aws_route_table.environment.id}"
}

output "availability_zone" {
  value = "${aws_subnet.environment.availability_zone}"
}
