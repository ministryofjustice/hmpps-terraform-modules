output "vpc_id" {
  value = aws_vpc.environment.id
}

output "vpc_cidr" {
  value = aws_vpc.environment.cidr_block
}

