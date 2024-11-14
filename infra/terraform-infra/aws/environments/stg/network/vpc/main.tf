provider "aws" {
  region = "ap-northeast-1"  #  region
}

module "dr-vpc" {
  source          = "../../../../modules/network/vpc" 
                                              
  main_vpc_cidr           = "10.20.0.0/16"
  private_subnet_count    = 2
  public_subnet_count     = 2
  db_subnet_count         = 2
  bastion_subnet_count    = 1
  db_bastion_subnet_count = 1
  availability_zones      = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  vpc_tags                = {Description = "Create by terraform", GBL_PROJECT = "IaC", GBL_CLASS_0 = "SERVICE", GBL_CLASS_1 = "VPC"}
  name_suffix             = "stg-apne1" 
}

