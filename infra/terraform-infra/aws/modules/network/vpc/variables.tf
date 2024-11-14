variable "main_vpc_cidr" {}

variable "public_subnet_count" {
  description = "The number of public subnets to create"
  type        = number
  default     = 3
}

variable "private_subnet_count" {
  description = "The number of private subnets to create"
  type        = number
  default     = 3
}

variable "db_subnet_count" {
  description = "The number of db subnets to create"
  type        = number
  default     = 3
}

variable "bastion_subnet_count" {
  description = "The number of bastion subnets to create"
  type        = number
  default     = 1
}

variable "db_bastion_subnet_count" {
  description = "The number of db bastion subnets to create"
  type        = number
  default     = 1
}

variable "availability_zones" {
  description = "The availability zones for the subnets"
  type        = list(string)
  default     = []
}

variable "vpc_tags" {
  description = "A map of tags to assign"
  type        = map(string)
  default     = {}
}

variable "s3_tags" {
  description = "A map of tags to assign"
  type        = map(string)
  default     = {}
}
variable "name_suffix" {
  description = "Suffix to append to resource names"
  type        = string
  default     = ""
}