output "bastion_sg_id" {
  description = "The ID of the created security group"
  value       = module.sg-bastion.security_group_id
}

output "common_sg_id" {
  description = "The ID of the created security group"
  value       = module.sg-common.security_group_id
}

output "db_bastion_sg_id" {
  description = "The ID of the created security group"
  value       = module.sg-db-bastion.security_group_id
}

output "db_app_sg_id" {
  description = "The ID of the created security group"
  value       = module.sg-db-app.security_group_id
}

output "tun_sg_id" {
  description = "The ID of the created security group"
  value       = module.sg-tun.security_group_id
}

output "rla_sg_id" {
  description = "The ID of the created security group"
  value       = module.sg-rla.security_group_id
}

output "prs_sg_id" {
  description = "The ID of the created security group"
  value       = module.sg-prs.security_group_id
}

output "sca_sg_id" {
  description = "The ID of the created security group"
  value       = module.sg-sca.security_group_id
}

output "sca_elb_sg_id" {
  description = "The ID of the created security group"
  value       = module.sg-sca-elb.security_group_id
} 
output "rds_sg_id" {
  description = "The ID of the created security group"
  value       = module.sg-rds.security_group_id
} 
