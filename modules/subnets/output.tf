output "subnetid" {
  value = ["${aws_subnet.environment.*.id}"]
}

output "routetableid" {
   value = ["${aws_route_table.environment.*.id}"]
}
