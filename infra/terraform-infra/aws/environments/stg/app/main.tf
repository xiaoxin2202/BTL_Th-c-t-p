provider "aws" {
  region = "ap-northeast-1"
}

locals {
  name_suffix               = "apne1"
  env                       = "stg"
  region_code               = "jp"
  region_length             = "ap-northeast-1"
  availability_zones        = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]

  bastion_ami               = "ami-0ac6b9b2908f3e20d"
  db_bastion_ami            = "ami-0ac6b9b2908f3e20d"
  sca_ami                   = "ami-0ac6b9b2908f3e20d"
  prs_ami                   = "ami-0ac6b9b2908f3e20d"
  rla_ami                   = "ami-0ac6b9b2908f3e20d"
  tun_ami                   = "ami-0ac6b9b2908f3e20d"
  
  bastion_instance_type     = "t2.micro"
  db_bastion_instance_type  = "t2.micro"
  sca_instance_type         = "t2.micro"
  prs_instance_type         = "t2.micro"
  rla_instance_type         = "t2.micro"
  tun_instance_type         = "t2.micro"

  bastion_number            = 1
  db_bastion_number         = 0
  sca_number                = 1
  prs_number                = 0
  rla_number                = 0
  tun_number                = 0
}

# create sca alb 
module "dr-elb-sca" {
  source                = "../../../modules/app/alb"
  ssl_policy            = "ELBSecurityPolicy-TLS-1-2-2017-01"
  //certificate_arn       = "arn:aws:acm:ap-northeast-1:580703956764:certificate/95ec03b6-fca0-454c-bd3c-31ba5a9ada5c"
  vpc_id                = data.terraform_remote_state.state_vpc.outputs.public_vpc_id
  security_group_ids    = [data.terraform_remote_state.state_sg.outputs.sca_elb_sg_id]
  subnet_ids            = data.terraform_remote_state.state_vpc.outputs.public_subnet_ids
  name_suffix           = local.name_suffix
}

# create role
module "dr-role-s3" {
  source                = "../../../modules/app/role"
}

# create bastion
module "dr-ec2-bastion" {
  source                    = "../../../modules/app/ec2"
  ec2_count                 = local.bastion_number
  name                      = "bastion"
  ami_id                    = local.bastion_ami 
  instance_type             = local.bastion_instance_type
  keypair                   = "bastion-dr-apne1"
  public_ip                 = true
  role                      = module.dr-role-s3.profile_name
  user_data_file            = "../../../modules/app/ec2/userdata/adm_v1.tpl"
  vpc_security_group_ids    = [
    data.terraform_remote_state.state_sg.outputs.bastion_sg_id,
    data.terraform_remote_state.state_sg.outputs.common_sg_id
  ]
  subnet_ids                = data.terraform_remote_state.state_vpc.outputs.bastion_subnet_ids
  name_suffix               = local.name_suffix
  root_volume_size          = 30
  root_volume_type          = "gp2"
  ec2_tags                  = {
    GBL_PROJECT = "SCS", 
    GBL_CLASS_0 = "OPERATION", 
    SEC_ASSETS_GATEWAY = "GENERAL", 
    GBL_CLASS_1 = "BASTION"}
}

# create db bastion
module "dr-ec2-db-bastion" {
  source                    = "../../../modules/app/ec2"
  ec2_count                 = local.db_bastion_number
  name                      = "db-bastion"
  ami_id                    = local.db_bastion_ami 
  instance_type             = local.db_bastion_instance_type
  keypair                   = "bastion-dr-apne1"
  public_ip                 = true
  user_data_file            = "../../../modules/app/ec2/userdata/base_v1.tpl"
  vpc_security_group_ids    = [
    data.terraform_remote_state.state_sg.outputs.db_bastion_sg_id,
    data.terraform_remote_state.state_sg.outputs.common_sg_id
  ]
  subnet_ids                = data.terraform_remote_state.state_vpc.outputs.db_bastion_subnet_ids
  name_suffix               = local.name_suffix
  root_volume_size          = 30
  root_volume_type          = "gp2"  
  ec2_tags                  = {
    GBL_PROJECT = "SCS", 
    GBL_CLASS_0 = "OPERATION", 
    SEC_ASSETS_GATEWAY = "GENERAL", 
    GBL_CLASS_1 = "DB-BASTION"}
}

# create sca
module "dr-ec2-sca" {
  source                    = "../../../modules/app/ec2"
  ec2_count                 = local.sca_number
  name                      = "sca"
  ami_id                    = local.sca_ami
  instance_type             = local.sca_instance_type
  keypair                   = "bastion-dr-apne1"
  public_ip                 = false
  role                      = module.dr-role-s3.profile_name
  user_data_file            = "../../../modules/app/ec2/userdata/base_v1.tpl"
  vpc_security_group_ids    = [
    data.terraform_remote_state.state_sg.outputs.sca_sg_id,
    data.terraform_remote_state.state_sg.outputs.common_sg_id,
    data.terraform_remote_state.state_sg.outputs.db_app_sg_id
  ]
  subnet_ids                = data.terraform_remote_state.state_vpc.outputs.private_subnet_ids  
  name_suffix               = local.name_suffix
  env                       = local.env
  region_code               = local.region_code
  region_length             = local.region_length
  sca_tg                    = module.dr-elb-sca.sca_tg
  root_volume_size          = 30
  root_volume_type          = "gp2"  
  ec2_tags                  = {
    GBL_PROJECT = "SCS", 
    GBL_CLASS_0 = "SERVICE", 
    GBL_CLASS_1 = "SCA"}
}

module "dr-ec2-prs" {
  source                    = "../../../modules/app/ec2"
  ec2_count                 = local.prs_number
  name                      = "prs"
  ami_id                    = local.prs_ami
  instance_type             = local.prs_instance_type
  keypair                   = "bastion-dr-apne1"
  public_ip                 = true
  role                      = module.dr-role-s3.profile_name
  user_data_file            = "../../../modules/app/ec2/userdata/base_v1.tpl"
  vpc_security_group_ids    = [
    data.terraform_remote_state.state_sg.outputs.prs_sg_id,
    data.terraform_remote_state.state_sg.outputs.common_sg_id,
    data.terraform_remote_state.state_sg.outputs.db_app_sg_id
  ]
  subnet_ids                = data.terraform_remote_state.state_vpc.outputs.public_subnet_ids  
  name_suffix               = local.name_suffix
  env                       = local.env
  region_code               = local.region_code
  region_length             = local.region_length
  root_volume_size          = 30
  root_volume_type          = "gp2"  
  ec2_tags                  = {
    GBL_PROJECT = "SCS", 
    GBL_CLASS_0 = "SERVICE", 
    GBL_CLASS_1 = "PRS"}
}

module "dr-ec2-rla" {
  source                    = "../../../modules/app/ec2"
  ec2_count                 = local.rla_number
  name                      = "rla"
  ami_id                    = local.rla_ami
  instance_type             = local.rla_instance_type
  keypair                   = "bastion-dr-apne1"
  public_ip                 = true
  role                      = module.dr-role-s3.profile_name
  user_data_file            = "../../../modules/app/ec2/userdata/base_v1.tpl"
  vpc_security_group_ids    = [
    data.terraform_remote_state.state_sg.outputs.rla_sg_id,
    data.terraform_remote_state.state_sg.outputs.common_sg_id,
    data.terraform_remote_state.state_sg.outputs.db_app_sg_id
  ]
  subnet_ids                = data.terraform_remote_state.state_vpc.outputs.public_subnet_ids  
  name_suffix               = local.name_suffix
  env                       = local.env
  region_code               = local.region_code
  region_length             = local.region_length
  root_volume_size          = 30
  root_volume_type          = "gp2"  
  ec2_tags                  = {
    GBL_PROJECT = "SCS", 
    GBL_CLASS_0 = "SERVICE", 
    GBL_CLASS_1 = "RLA"}
}

module "dr-ec2-tun" {
  source                    = "../../../modules/app/ec2"
  ec2_count                 = local.tun_number
  name                      = "tun"
  ami_id                    = local.tun_ami
  instance_type             = local.tun_instance_type
  keypair                   = "bastion-dr-apne1"
  public_ip                 = true
  role                      = module.dr-role-s3.profile_name
  user_data_file            = "../../../modules/app/ec2/userdata/base_v1.tpl"
  vpc_security_group_ids    = [
    data.terraform_remote_state.state_sg.outputs.tun_sg_id,
    data.terraform_remote_state.state_sg.outputs.common_sg_id,
    data.terraform_remote_state.state_sg.outputs.db_app_sg_id
  ]
  subnet_ids                = data.terraform_remote_state.state_vpc.outputs.public_subnet_ids  
  name_suffix               = local.name_suffix
  env                       = local.env
  region_code               = local.region_code
  region_length             = local.region_length
  root_volume_size          = 30
  root_volume_type          = "gp2"  
  ec2_tags                  = {
    GBL_PROJECT = "SCS", 
    GBL_CLASS_0 = "SERVICE", 
    GBL_CLASS_1 = "TUN"}
}
