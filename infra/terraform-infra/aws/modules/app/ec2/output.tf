output "private_ip" {
  description = "private_ip"
  value       = aws_instance.ec2[*].private_ip
}
output "public_ip" {
  description = "public_ip"
  value       = aws_eip.elasticip[*].public_ip
}