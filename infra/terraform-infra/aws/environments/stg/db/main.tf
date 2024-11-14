provider "aws" {
  region = "ap-northeast-1"
}

module "dr-db" {
  source            = "../../../modules/db"
  db_instance_identifier    = "iac-db-apne1"
  db_instance_class         = "db.t3.medium"
  db_storage_capacity       = 50
  db_storage_type           = "gp3"
  db_port                   = 9306
  username                  = "admin"
  password                  = "Admindb!"
  db_parameters            = [
    {
      name  = "max_connections"
      value = "1000"
    }
  ]
  skip_final_snapshot = true
  vpc_security_group_ids    = [data.terraform_remote_state.state_sg.outputs.rds_sg_id]
  subnet_ids                =  data.terraform_remote_state.state_vpc.outputs.db_subnet_ids
  db_tags                   = {
    GBL_PROJECT = "IAC", 
    GBL_CLASS_0 = "SERVICE", 
    GBL_CLASS_1 = "DB",
    COST_SCHEDULE_GROUP_NAME = "rds"}
}



