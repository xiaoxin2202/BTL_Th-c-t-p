resource "aws_iam_role" "s3fullaccessrole" {
  name = "s3fullaccessrole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "s3fullaccesspolicy" {
  name        = "s3fullaccesspolicy"
  description = "A policy that grants S3 full access"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "s3:*",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_full_access_policy_attachment" {
  role       = aws_iam_role.s3fullaccessrole.name
  policy_arn = aws_iam_policy.s3fullaccesspolicy.arn
}

resource "aws_iam_instance_profile" "s3_full_access_instance_profile" {
  name = "s3-full-access-instance-profile"
  role = aws_iam_role.s3fullaccessrole.name
}