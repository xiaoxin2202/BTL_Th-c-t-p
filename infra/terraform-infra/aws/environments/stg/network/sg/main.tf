provider "aws" {
  region = "ap-northeast-1"  #  region
}

module "sg-bastion" {
  source            = "../../../../modules/network/sg" 
  vpc_id            = data.terraform_remote_state.state_vpc.outputs.public_vpc_id
  name              = "bastion-sg"
  description       = "Create by terraform"
  ingress_rules     = []
  egress_rules      = []
}

module "sg-common" {
  source            = "../../../../modules/network/sg" 
  vpc_id            = data.terraform_remote_state.state_vpc.outputs.public_vpc_id
  name              = "common-sg"
  description       = "Create by terraform"
  ingress_rules     = [
    { from_port = 2222, to_port = 2222, protocol = "tcp", cidr_blocks = [], security_groups  = [module.sg-bastion.security_group_id], description = "Access from bastion"}
  ]
  egress_rules      = [
    {from_port = 53, to_port = 53, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], security_groups = [], description = "DNS server"},
    {from_port = 53, to_port = 53, protocol = "udp", cidr_blocks = ["0.0.0.0/0"], security_groups = [], description = "DNS server"}
  ]
}


module "sg-rds" {
  source            = "../../../../modules/network/sg" 
  vpc_id            = data.terraform_remote_state.state_vpc.outputs.public_vpc_id
  name              = "rds-sg"
  description       = "Create by terraform"
  ingress_rules     = []
  egress_rules      = []
}

module "sg-db-bastion" {
  source            = "../../../../modules/network/sg" 
  vpc_id            = data.terraform_remote_state.state_vpc.outputs.public_vpc_id
  name              = "db-bastion-sg"
  description       = "Create by terraform"
  ingress_rules     = [
    { from_port = 2222, to_port = 2222, protocol = "tcp", cidr_blocks = ["112.106.111.204/32","112.106.111.205/32"], security_groups  = [], description = "Access from DBAS"},
    { from_port = 2222, to_port = 2222, protocol = "tcp", cidr_blocks = ["211.189.57.60/32"], security_groups  = [], description = "Access from SBC"}
  ]
  egress_rules      = [
     { from_port = 9306, to_port = 9306, protocol = "tcp", cidr_blocks = [], security_groups  = [module.sg-rds.security_group_id], description = "Access to RDS"}
  ]
}



module "sg-db-app" {
  source            = "../../../../modules/network/sg" 
  vpc_id            = data.terraform_remote_state.state_vpc.outputs.public_vpc_id
  name              = "db-app-sg"
  description       = "Create by terraform"
  ingress_rules     = []
  egress_rules      = [
     { from_port = 9306, to_port = 9306, protocol = "tcp", cidr_blocks = [], security_groups  = [module.sg-rds.security_group_id], description = "Access to RDS"}
  ]
}

module "sg-tun" {
  source            = "../../../../modules/network/sg" 
  vpc_id            = data.terraform_remote_state.state_vpc.outputs.public_vpc_id
  name              = "tun-sg"
  description       = "Create by terraform"
  ingress_rules     = [
    { from_port = 3478, to_port = 3478, protocol = "udp", cidr_blocks = ["0.0.0.0/0"], security_groups  = [], description = "STUN UDP service"},
    { from_port = 9090, to_port = 9090, protocol = "udp", cidr_blocks = ["0.0.0.0/0"], security_groups  = [], description = "STUN UDP service"},
    { from_port = 3478, to_port = 3478, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], security_groups  = [], description = "STUN TCP service"},
    { from_port = 9090, to_port = 9090, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], security_groups  = [], description = "STUN TCP service"}
  ]
  egress_rules      = [
     { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], security_groups  = [], description = "Push log to SPC"},
     { from_port = 49152, to_port = 65535, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], security_groups  = [], description = "STUN TCP service"},
     { from_port = 49152, to_port = 65535, protocol = "udp", cidr_blocks = ["0.0.0.0/0"], security_groups  = [], description = "STUN UDP service"}
  ]
}

module "sg-rla" {
  source            = "../../../../modules/network/sg" 
  vpc_id            = data.terraform_remote_state.state_vpc.outputs.public_vpc_id
  name              = "rla-sg"
  description       = "Create by terraform"
  ingress_rules     = [
    { from_port = 8080, to_port = 8080, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], security_groups  = [], description = "Relay service"},
    { from_port = 9090, to_port = 9090, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], security_groups  = [], description = "Relay service"}
  ]
  egress_rules      = [
     { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], security_groups  = [], description = "Push log to SPC"}
  ]
}

module "sg-prs" {
  source            = "../../../../modules/network/sg" 
  vpc_id            = data.terraform_remote_state.state_vpc.outputs.public_vpc_id
  name              = "prs-sg"
  description       = "Create by terraform"
  ingress_rules     = [
    { from_port = 8080, to_port = 8080, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], security_groups  = [], description = "Presence service"},
    { from_port = 9090, to_port = 9090, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], security_groups  = [], description = "Presence service"}
  ]
  egress_rules      = [
     { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"], security_groups  = [], description = "Removing tracking connection"}
  ]
}

module "sg-sca" {
  source            = "../../../../modules/network/sg" 
  vpc_id            = data.terraform_remote_state.state_vpc.outputs.public_vpc_id
  name              = "sca-sg"
  description       = "Create by terraform"
  ingress_rules     = []
  egress_rules      = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], security_groups  = [], description = "Access to Samsung Account"},
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], security_groups  = [], description = "Access to Samsung Account"}
  ]
}

module "sg-sca-elb" {
  source            = "../../../../modules/network/sg" 
  vpc_id            = data.terraform_remote_state.state_vpc.outputs.public_vpc_id
  name              = "sca-elb-sg"
  description       = "Create by terraform"
  ingress_rules     = [
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], security_groups  = [], description = "SCA service"}
  ]
  egress_rules      = [
    { from_port = 8080, to_port = 8080, protocol = "tcp", cidr_blocks = [], security_groups  = [module.sg-sca.security_group_id], description = "Access to SCA"}
  ]
}

module "sg-bastion-rule" {
  source            = "../../../../modules/network/sg_rule"
  security_group_id = module.sg-bastion.security_group_id
  ingress_rules     = [
    { from_port = 2222, to_port = 2222, protocol = "tcp", cidr_blocks = ["211.189.57.60/32"], security_groups  = [], description = "Access from SBC"},
    { from_port = 2222, to_port = 2222, protocol = "tcp", cidr_blocks = ["54.199.175.139/32"], security_groups  = [], description = "Access from bastion AN tmp"}
  ]
  egress_rules      = [
    { from_port = 2222, to_port = 2222, protocol = "tcp", cidr_blocks = [], security_groups = [module.sg-common.security_group_id], description = "Access to all instances"},
  ]
}

module "sg-rds-rule" {
  source            = "../../../../modules/network/sg_rule"
  security_group_id = module.sg-rds.security_group_id
  ingress_rules = [
    { from_port = 9306, to_port = 9306, protocol = "tcp", cidr_blocks = [], security_groups = [module.sg-db-bastion.security_group_id], description = "Access from DB Gateway"},
    { from_port = 9306, to_port = 9306, protocol = "tcp", cidr_blocks = [], security_groups = [module.sg-db-app.security_group_id], description = "Access from apps"}
  ]
  egress_rules = []
}

module "sg-sca-rule" {
  source            = "../../../../modules/network/sg_rule"
  security_group_id = module.sg-sca.security_group_id
  ingress_rules = [
    { from_port = 8080, to_port = 8080, protocol = "tcp", cidr_blocks = [], security_groups  = [module.sg-sca-elb.security_group_id], description = "Access from SCA ELB"}
  ]
  egress_rules = []
}