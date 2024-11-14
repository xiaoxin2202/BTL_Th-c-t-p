# Create vpc
resource "aws_vpc" "Main" {            # Creating VPC here
  cidr_block       = var.main_vpc_cidr # Defining the CIDR block 
  instance_tenancy = "default"
  
  tags = merge(var.vpc_tags, {Name = format("iac-vpc-%s", var.name_suffix)}, {GBL_CLASS_2 = "VPC"})
}

resource "aws_internet_gateway" "IGW" { # Creating Internet Gateway
  vpc_id = aws_vpc.Main.id              # vpc_id will be generated after we create VPC
  
  tags = merge(var.vpc_tags, {Name = format("internet-gateway-%s", var.name_suffix)}, {GBL_CLASS_2 = "Internet Gateway"})
}

# create subnet
locals {
  public_cidrs        = [for i in range(var.public_subnet_count) : cidrsubnet(var.main_vpc_cidr, 8, i)]
  private_cidrs       = [for i in range(var.private_subnet_count) : cidrsubnet(var.main_vpc_cidr, 8, i+10)]
  db_cidrs            = [for i in range(var.db_subnet_count) : cidrsubnet(var.main_vpc_cidr, 8, i+20)]
  bastion_cidrs       = [for i in range(var.bastion_subnet_count) : cidrsubnet(var.main_vpc_cidr, 8, i+30)]
  db_bastion_cidrs    = [for i in range(var.db_bastion_subnet_count) : cidrsubnet(var.main_vpc_cidr, 8, i+40)]
}

resource "aws_subnet" "public" {
  count = var.public_subnet_count

  vpc_id                  = aws_vpc.Main.id
  cidr_block              = local.public_cidrs[count.index]
  availability_zone       = length(var.availability_zones) > 0 ? var.availability_zones[count.index % length(var.availability_zones)] : null
  map_public_ip_on_launch = true

  tags = merge(var.vpc_tags, {Name = "public-subnet-${count.index + 1}"}, {GBL_CLASS_2 = "Public Subnet"})
}

resource "aws_subnet" "private" {
  count = var.private_subnet_count

  vpc_id                  = aws_vpc.Main.id
  cidr_block              = local.private_cidrs[count.index]
  availability_zone       = length(var.availability_zones) > 0 ? var.availability_zones[count.index % length(var.availability_zones)] : null

  tags = merge(var.vpc_tags, {Name = "private-subnet-${count.index + 1}"}, {GBL_CLASS_2 = "Private Subnet"})
}

resource "aws_subnet" "db" {
  count = var.db_subnet_count

  vpc_id                  = aws_vpc.Main.id
  cidr_block              = local.db_cidrs[count.index]
  availability_zone       = length(var.availability_zones) > 0 ? var.availability_zones[count.index % length(var.availability_zones)] : null

  tags = merge(var.vpc_tags, {Name = "db-subnet-${count.index + 1}"}, {GBL_CLASS_2 = "Database Subnet"})
}

resource "aws_subnet" "bastion" {
  count = var.bastion_subnet_count

  vpc_id                  = aws_vpc.Main.id
  cidr_block              = local.bastion_cidrs[count.index]
  availability_zone       = length(var.availability_zones) > 0 ? var.availability_zones[count.index % length(var.availability_zones)] : null

  tags = merge(var.vpc_tags, {Name = "bastion-subnet-${count.index + 1}"}, {GBL_CLASS_2 = "Gateway Subnet"})
}

resource "aws_subnet" "db_bastion" {
  count = var.db_bastion_subnet_count

  vpc_id                  = aws_vpc.Main.id
  cidr_block              = local.db_bastion_cidrs[count.index]
  availability_zone       = length(var.availability_zones) > 0 ? var.availability_zones[count.index % length(var.availability_zones)] : null

  tags = merge(var.vpc_tags, {Name = "db-bastion-subnet-${count.index + 1}"}, {GBL_CLASS_2 = "Database Gateway Subnet"})
}
# end create subnet
# create route table 
# public
resource "aws_route_table" "public" { # Creating Router Table for Public Subnet
  count = var.public_subnet_count
  
  vpc_id                  = aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
  }
  
  tags = merge(var.vpc_tags, {Name = "public-rt-app-${count.index + 1}"}, {GBL_CLASS_2 = "Public Route Table"})
}

resource "aws_route_table_association" "public" { # Attach PublicRouterTable to Public subnet
  count = var.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}
# bastion
resource "aws_route_table" "bastion" { # Creating Router Table for Public Subnet
  count = var.bastion_subnet_count
  
  vpc_id                  = aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
  }
  
  tags = merge(var.vpc_tags, {Name = "public-rt-bastion-${count.index + 1}"}, {GBL_CLASS_2 = "Public Route Table"})
}

resource "aws_route_table_association" "bastion" { # Attach PublicRouterTable to Public subnet
  count = var.bastion_subnet_count
  subnet_id      = aws_subnet.bastion[count.index].id
  route_table_id = aws_route_table.bastion[count.index].id
}
# db bastion
resource "aws_route_table" "db_bastion" { # Creating Router Table for Public Subnet
  count = var.db_bastion_subnet_count
  
  vpc_id                  = aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
  }
  
  tags = merge(var.vpc_tags, {Name = "public-rt-db-bastion-${count.index + 1}"}, {GBL_CLASS_2 = "Public Route Table"})
}

resource "aws_route_table_association" "db_bastion" { # Attach PublicRouterTable to Public subnet
  count = var.db_bastion_subnet_count
  subnet_id      = aws_subnet.db_bastion[count.index].id
  route_table_id = aws_route_table.db_bastion[count.index].id
}

# end public
# private
resource "aws_eip" "EIP" { # create elastic IP for NAT
  count = var.private_subnet_count

  tags = merge(var.vpc_tags, {Name = "elastic-ip-${count.index + 1}"}, {GBL_CLASS_2 = "Elastic IP"})
}

resource "aws_nat_gateway" "NGW" { # create NAT 
  count = var.private_subnet_count
  
  allocation_id = aws_eip.EIP[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.vpc_tags, {Name = "nat-gateway-${count.index + 1}"}, {GBL_CLASS_2 = "Nat Gateway"})
}

resource "aws_route_table" "private" { # Creating RT for Private Subnet
  count = var.private_subnet_count

  vpc_id = aws_vpc.Main.id
  route {
    cidr_block     = "0.0.0.0/0" # Traffic from Private Subnet reaches Internet via NAT Gateway
    nat_gateway_id = aws_nat_gateway.NGW[count.index].id
  }

  tags = merge(var.vpc_tags, {Name = "private-rt-app-${count.index + 1}"}, {GBL_CLASS_2 = "Private Route Table"})
}

resource "aws_route_table_association" "private" { # Attach PrivateRouterTable to Private subnet
  count = var.private_subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
# end private
# db
resource "aws_route_table" "db" { # Creating RT for Private Subnet
  count = var.db_subnet_count

  vpc_id = aws_vpc.Main.id

  tags = merge(var.vpc_tags, {Name = "private-rt-db-${count.index + 1}"}, {GBL_CLASS_2 = "Database Route Table"})
}

resource "aws_route_table_association" "db" { # Attach PrivateRouterTable to Private subnet
  count = var.db_subnet_count
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db[count.index].id
}
# end db
# end create route table 