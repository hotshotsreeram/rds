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
    security_groups = ["sg-0c5503f90e6722373"]
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
  db_name                 = var.name
  username             = var.username
  password             = var.password
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db-subnet.name
  vpc_security_group_ids = [aws_security_group.database-security-group.id]
}
