variable "username" {
  description = "username for access"
  type        = string
}

variable "password" {
  description = "passpord for access"
  type        = string
}

variable "db_instance_identifier" {
  description = "The RDS instance identifier"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS instance"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs to assign to the RDS instance"
  type        = list(string)
}

variable "db_instance_class" {
  description = "db_instance_class"
  type        = string
}
variable "db_storage_capacity" {
  description = "db_storage"
  type        = number
}
variable "db_storage_type" {
  description = "db_storage"
  type        = string
}
variable "db_tags" {
  description = "Tags db instances"
  type        = map(string)
  default     = {}
}
variable "skip_final_snapshot" {
  description = "Whether to skip creating a final snapshot before deleting the DB instance"
  type        = bool
  default     = false
}
variable "db_parameters" {
  description = "List of DB parameters"
  type        = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "max_connections"
      value = "1000"
    }
  ]
}
variable "db_port"{
}