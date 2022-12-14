terraform {
  required_version = ">=0.12"
}

provider "aws" {
  region  = var.aws_region
}

resource "aws_vpc" "db_vpc" {
  cidr_block = var.custom_vpc

  tags = {
    Name = var.vpc_tags
  }
}

resource "aws_subnet" "db_private_subnet" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = var.private_subnet1
  availability_zone = var.aws_zone1

  tags = {
    Name = var.private_subnet_tags1
  }
}

resource "aws_subnet" "db_private_subnet2" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = var.private_subnet2
  availability_zone = var.aws_zone2

  tags = {
    Name = var.private_subnet_tags2
  }
}

resource "aws_subnet" "project_public_subnet" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = var.public_subnet
  availability_zone = var.aws_zone2

  tags = {
    Name = var.public_subnet_tags
  }
}

resource "aws_internet_gateway" "project_ig" {
  vpc_id = aws_vpc.db_vpc.id

  tags = {
    Name = var.internet_gateway_tags
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.db_vpc.id

  route {
    cidr_block = var.route_table
    gateway_id = aws_internet_gateway.project_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.project_ig.id
  }

  tags = {
    Name = var.route_table_tags
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.project_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_db_subnet_group" "db-subnet" {
name = "db-subnet-group"
subnet_ids = [aws_subnet.db_private_subnet.id, aws_subnet.db_private_subnet2.id]


  tags = {
    Name = var.subnet-group-name
  }
}


resource "aws_security_group" "database-security-group"{
  name = "Database Security Group"
  description = "Enable  MYSQL Aurora access on Port 3306"
  vpc_id = aws_vpc.db_vpc.id

  ingress{
    description = "MYSQL/Aurora Access"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "database-security-group"
  }
}
resource "aws_db_instance" "practice_instance" {
  allocated_storage    = 10
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  identifier           = var.identifier
  username             = var.username
  password             = var.password
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db-subnet.name
}
