variable "ec2_count" {
  description = "Số lượng EC2 instances bastion cần tạo"
  type        = number
}

variable "public_ip" {
  description = "Số lượng EC2 instances bastion cần tạo"
  type        = bool
}

variable "name" {
  description = "tên EC2 instances bastion cần tạo"
  type        = string
}

variable "ami_id" {
  description = "AMI ID để sử dụng cho EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Loại của EC2 instance bastion"
  type        = string
  default     = "t2.micro"
}

variable "keypair" {
  description = "Tên của key pair để truy cập EC2 instances"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Danh sách các security group IDs cho EC2 instances"
  type        = list(string)
}

variable "subnet_ids" {
  description = "Danh sách các subnet IDs cho EC2 instances"
  type        = list(string)
}

variable "user_data_file" {
  description = "Đường dẫn đến file user data cho EC2 instances"
  type        = string
  default     = ""
}

variable "ec2_tags" {
  description = "Tags áp dụng cho các EC2 instances"
  type        = map(string)
  default     = {}
}

variable "name_suffix" {
  description = "Hậu tố cho tên các instances"
  type        = string
  default     = "instance"
}

variable "region_code"{
  description = "region code for instances"
  type        = string
  default     = ""
}

variable "env"{
  description = "enviroment for instances"
  type        = string
  default     = ""
}

variable "region_length"{
  description = "region for instances"
  type        = string
  default     = "ap-northeast-1"
}

variable "username_db"{
  description = "username_db for instances"
  type        = string
  default     = ""
}
variable "password_db"{
  description = "password_db for instances"
  type        = string
  default     = ""
}
variable "endpoint_db"{
  description = "endpoint_db for instances"
  type        = string
  default     = ""
}

variable "sca_tg"{
  description = "sca_tg for instances"
  type        = string
  default     = ""
}

variable "role" {
  description = "role for instances"
  type        = string
  default     = ""
}

variable "root_volume_size" {
}

variable "root_volume_type" {
}