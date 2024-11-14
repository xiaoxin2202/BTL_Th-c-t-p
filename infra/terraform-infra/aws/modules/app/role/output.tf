output "profile_name" {
  description = "The ID of the created security group"
  value       = aws_iam_instance_profile.s3_full_access_instance_profile.name
}