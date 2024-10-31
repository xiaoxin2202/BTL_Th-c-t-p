terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "ap-southeast-1"
  access_key = "***"
  secret_key = "***"
}


# Tạo VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-southeast-1a"
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-southeast-1b"
}

# Tạo Security Group
resource "aws_security_group" "example" {
  vpc_id = aws_vpc.example.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Mở tất cả traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Mở tất cả traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Tạo S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = "btl1"
}

# Tạo EC2 Instances
resource "aws_instance" "nginx" {
  ami             = "ami-047126e50991d067b"  # Chọn AMI phù hợp với khu vực đầu tiên
  instance_type   = "t2.micro"
  tags = {
    Name = "Instance1"
  }
}

resource "aws_instance" "nodejs" {
  ami             = "ami-047126e50991d067b"  # Chọn AMI phù hợp với khu vực thứ hai
  instance_type   = "t2.micro"
  tags = {
    Name = "Instance2"
  }
}