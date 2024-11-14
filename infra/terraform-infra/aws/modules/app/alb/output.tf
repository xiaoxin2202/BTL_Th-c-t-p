output "sca_tg" {
  description = "sca_tg"
  value       = aws_lb_target_group.sca.arn
}
output "sca_alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.sca.dns_name
}