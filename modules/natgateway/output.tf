output "natid" {
  value = aws_nat_gateway.environment.id
}

output "nat_public_ip" {
  value = aws_nat_gateway.environment.public_ip
}

output "nat_private_ip" {
  value = aws_nat_gateway.environment.private_ip
}

