variable "security_group_id" {
  description = "The ID of the security group to add rules to"
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules to add"
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
  description = "List of egress rules to add"
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