variable "vpc_id" {}

variable "name" {
  description = "The name of the security group"
  type        = string
}

variable "description" {
  description = "A description of the security group"
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules to apply"
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    security_groups  = list(string)
    description      = string
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules to apply"
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    security_groups  = list(string)
    description      = string
  }))
  default = []
}