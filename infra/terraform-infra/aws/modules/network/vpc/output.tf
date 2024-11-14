output "public_vpc_id" {
  value = aws_vpc.Main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "db_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.db[*].id
}

output "bastion_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.bastion[*].id
}

output "db_bastion_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.db_bastion[*].id
}
