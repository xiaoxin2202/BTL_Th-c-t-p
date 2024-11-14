# config endpoint of resource in SPC
terraform {
  required_version = ">= 1.1.0, < 2.0.0" # Replace with the desired Terraform version

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.40.0"
    }
  }
}

variable "region" {
  default     = "ap-northeast-1" # Replace with the target region
  description = "region name"
}

