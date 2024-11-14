resource "aws_db_instance" "db" {
  identifier              = var.db_instance_identifier
  instance_class          = var.db_instance_class 
  engine                  = "mysql"
  engine_version          = "8.0.36"
  allocated_storage       = var.db_storage_capacity
  storage_type            = var.db_storage_type
  db_subnet_group_name    = aws_db_subnet_group.db.name
  vpc_security_group_ids  = var.vpc_security_group_ids
  parameter_group_name    = aws_db_parameter_group.db.name
  port                    = var.db_port
  username                = var.username
  password                = var.password
  tags                    = var.db_tags
  skip_final_snapshot     = var.skip_final_snapshot
}

resource "aws_db_subnet_group" "db" {
  name       = "rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "Create by terraform"
  }
}

resource "aws_db_parameter_group" "db" {
  name   = "db-parameter-group-8-0"
  family = "mysql8.0"
  description = "Create by terraform"

  dynamic "parameter" {
    for_each = var.db_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = {
    Name = "db-parameter-group-8.0"
  }
}