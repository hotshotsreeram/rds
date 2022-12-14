variable "aws_zone1"{
  type = string
  description = "available aws zones"
}

variable "aws_zone2"{
  type = string
  description = "available aws zones"
}

variable "private_subnet_tags1"{
	type= string
	description= "tags for private subnet"
}

variable "vpc_tags"{
	type= string
	description= "tags for vpc"
}

variable "custom_vpc" {
  type        = string
  description = "custom vpc ip cidr block"
}

variable "private_subnet_tags2"{
	type= string
	description= "tags for private subnet"
}

variable "private_subnet1" {
  type        = string
  description = "private subnet ip cidr block"
}

variable "private_subnet2" {
  type        = string
  description = "private subnet ip cidr block"
}


variable "aws_region" {
  type        = string
  description = "aws region for the instance and lb"
}

variable "engine"{
  type = string
  description = "engine name"
}

variable "engine_version"{
  type = string
  description = "version of the engine"
}

variable "instance_class"{
  type = string
  description = "instance class"
}

variable "identifier"{
  type = string
  description = "db instance name"
}

variable "username"{
  type = string
  description = "db instance username"
}

variable "password"{
  type= string
  description = "db instance password"
}

variable "parameter_group_name"{
  type = string
  description = "parameter group name"
}

variable "subnet-group-name"{
  type = string
  description = "name of the subnet group"
}

variable "public_subnet_tags"{
	type= string
	description="tags for public subnet"
}

variable "internet_gateway_tags"{
	type= string
	description= "tags for internet gateway"
}

variable "route_table_tags"{
	type= string
	description= "tags for route table"
}

variable "public_subnet" {
  type        = string
  description = "public subnet ip cidr block"
}

variable "route_table" {
  type        = string
  description = "route table ip cidr block"
}