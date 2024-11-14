variable "vpc_id" {
  description = "The VPC ID where the ALB will be created"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the ALB will be deployed"
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs where the ALB will be deployed"
  type        = list(string)
}

variable "name_suffix" {
  description = "Suffix to append to resource names"
  type        = string
  default     = ""
}
variable "ssl_policy" {
  description = "ssl_policy"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}
variable "certificate_arn" {
  description = "certificate_arn"
  type        = string
  default     = ""
}