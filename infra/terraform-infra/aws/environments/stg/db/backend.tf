terraform { # push state to gage
  backend "s3" {
    bucket         = "iac-terraform-state-anh.cao" # bucket
    key            = "db/terraform.tfstate" # path to file in bucket
    region         = "ap-northeast-1"
    skip_s3_checksum = true
  }
}

data "terraform_remote_state" "state_vpc" { # get backend state from gage for get information of vpc
  backend = "s3" 
    config = {
      bucket  = "iac-terraform-state-anh.cao" # bucket
      region  = "ap-northeast-1"
      key     = "vpc/terraform.tfstate" # path to file in bucket
  }
}

data "terraform_remote_state" "state_sg" { # get backend state from gage for get information of security group
  backend = "s3" 
    config = {
      bucket  = "iac-terraform-state-anh.cao" # bucket
      region  = "ap-northeast-1"
      key     = "sg/terraform.tfstate" # path to file in bucket
  }
}


