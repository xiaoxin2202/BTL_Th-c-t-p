output "bastion_private_ip" {
  description = "private_ip"
  value       = module.dr-ec2-bastion[*].private_ip
}
output "bastion_public_ip" {
  description = "public_ip"
  value       = module.dr-ec2-bastion[*].public_ip
}
output "sca_private_ip" {
  description = "private_ip"
  value       = module.dr-ec2-sca[*].private_ip
}
output "sca_public_ip" {
  description = "sca_public_ip"
  value       = module.dr-ec2-sca[*].public_ip
}
output "prs_private_ip" {
  description = "private_ip"
  value       = module.dr-ec2-prs[*].private_ip
}
output "prs_public_ip" {
  description = "sca_public_ip"
  value       = module.dr-ec2-prs[*].public_ip
}
output "rla_private_ip" {
  description = "private_ip"
  value       = module.dr-ec2-rla[*].private_ip
}
output "rla_public_ip" {
  description = "rla_public_ip"
  value       = module.dr-ec2-rla[*].public_ip
}
output "tun_private_ip" {
  description = "private_ip"
  value       = module.dr-ec2-tun[*].private_ip
}
output "tun_public_ip" {
  description = "tun_public_ip"
  value       = module.dr-ec2-tun[*].public_ip
}
output "db_bastion_private_ip" {
  description = "private_ip"
  value       = module.dr-ec2-db-bastion[*].private_ip
}
output "db_bastion_public_ip" {
  description = "public_ip"
  value       = module.dr-ec2-db-bastion[*].public_ip
}

output "sca_alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.dr-elb-sca.sca_alb_dns_name
}
