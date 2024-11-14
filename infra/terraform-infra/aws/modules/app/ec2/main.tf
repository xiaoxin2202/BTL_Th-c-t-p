resource "aws_eip" "elasticip" {
  count = var.public_ip ? var.ec2_count : 0
  # instance = aws_instance.ec2[count.index].id
}

data "template_file" "user_data" {
  count = var.ec2_count
  template = var.user_data_file != "" ? file(var.user_data_file) : null
  vars = {
    name_suffix   = var.name_suffix
    name          = var.name
    region_code   = var.region_code
    region_length = var.region_length
    env           = var.env
    username_db   = var.username_db
    password_db   = var.password_db
    endpoint_db   = var.endpoint_db
    public_ip     = var.public_ip ? aws_eip.elasticip[count.index].public_ip : ""
  }
}

resource "aws_instance" "ec2" { # create instance bastion
  count = var.ec2_count
  ami           = var.ami_id
  instance_type = var.instance_type 
  key_name      = var.keypair
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id     = var.subnet_ids[count.index % length(var.subnet_ids)]
  user_data = var.user_data_file != "" ? data.template_file.user_data[count.index].rendered : null
  iam_instance_profile = var.role != "" ? var.role : null
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }
  tags = merge(var.ec2_tags, {Name = format("iac-%s-%s", var.name, var.name_suffix)})
}

resource "aws_eip_association" "elasticip" {
  count = var.public_ip ? var.ec2_count : 0
  instance_id          = aws_instance.ec2[count.index].id
  allocation_id        = aws_eip.elasticip[count.index].id
}

resource "aws_lb_target_group_attachment" "add-sca-tg" {
  count = var.name == "sca" ? var.ec2_count : 0
  target_group_arn = var.sca_tg
  target_id        = aws_instance.ec2[count.index].id
  port             = 8080
}
