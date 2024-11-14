terraform { # push state to gage
  backend "s3" {
    bucket  = "iac-terraform-state-anh.cao" # bucket
    region  = "ap-northeast-1"
    key    = "vpc/terraform.tfstate" # path to file in bucket
    skip_s3_checksum = true
  }
}
