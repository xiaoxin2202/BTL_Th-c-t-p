resource "aws_security_group_rule" "ingress" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }

  type                     = "ingress"
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  security_group_id        = var.security_group_id
  cidr_blocks              = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null
  source_security_group_id = length(each.value.security_groups) > 0 ? each.value.security_groups[0] : null
  description              = each.value.description
}

resource "aws_security_group_rule" "egress" {
  for_each = { for idx, rule in var.egress_rules : idx => rule }

  type                     = "egress"
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  security_group_id        = var.security_group_id
  cidr_blocks              = length(each.value.cidr_blocks) > 0  ? each.value.cidr_blocks : null
  source_security_group_id = length(each.value.security_groups) > 0 ? each.value.security_groups[0] : null
  description              = each.value.description
}