output "vpc_id" {
  value = aws_vpc.rds_vpc[0].id
}

output "subnet_ids" {
  value = aws_subnet.rds_private_subnets[*].id
}