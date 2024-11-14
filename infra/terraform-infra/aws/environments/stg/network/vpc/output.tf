# id output of vpc, subnet  

output "public_vpc_id" {
  value = module.dr-vpc.public_vpc_id # public_vpc_id is output.tf in /scs-devops/infra/terraform-infra/spc/modules/network/vpc/output.tf
}
output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = module.dr-vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = module.dr-vpc.private_subnet_ids
}

output "db_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = module.dr-vpc.db_subnet_ids
}

output "bastion_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = module.dr-vpc.bastion_subnet_ids
}

output "db_bastion_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = module.dr-vpc.db_bastion_subnet_ids
}
