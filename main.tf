provider "aws" {
  # profile = "default"
  region  = var.aws_region
}

# Networking VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block           = var.aws_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "tf_vpc"
  }
}

# Networking IGW
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "tf_igw"
  }
}

# Networking Route Tables
resource "aws_route_table" "tf_public_rt" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }
  tags = {
    Name = "tf_public_rt"
  }
}
resource "aws_default_route_table" "tf_private_rt" {
  default_route_table_id = aws_vpc.tf_vpc.default_route_table_id

  tags = {
    Name = "tf_private_rt"
  }
}

# Networking Subnets
resource "aws_subnet" "tf_public1_subnet" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.aws_cidrs["public1"]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "tf_public1"
  }
}
resource "aws_subnet" "tf_private1_subnet" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.aws_cidrs["private1"]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "tf_private1"
  }
}

# Networking Subnet Associations
resource "aws_route_table_association" "tf_public1_association" {
  subnet_id      = aws_subnet.tf_public1_subnet.id
  route_table_id = aws_route_table.tf_public_rt.id
}
resource "aws_route_table_association" "tf_private1_association" {
  subnet_id      = aws_subnet.tf_private1_subnet.id
  route_table_id = aws_default_route_table.tf_private_rt.id
}

# Security Group - Bastion Host (Developer)
resource "aws_security_group" "tf_dev_sg" {
  name        = "tf_dev_sg"
  description = "Used for private access to Dev instances"
  vpc_id      = aws_vpc.tf_vpc.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.localip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group - Private Instances
resource "aws_security_group" "tf_pri_sg" {
  name        = "tf_pri_sg"
  description = "Used for private instances"
  vpc_id      = aws_vpc.tf_vpc.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.aws_vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Key pair
resource "aws_key_pair" "tf_auth" {
  key_name   = var.key_name
  public_key = var.public_key
}

# Instance - Bastion Host (Developer)
resource "aws_instance" "tf_dev_instance" {
  ami                    = var.amis[var.aws_region]
  instance_type          = var.instance_type
  key_name               = aws_key_pair.tf_auth.id
  vpc_security_group_ids = [aws_security_group.tf_dev_sg.id]
  subnet_id              = aws_subnet.tf_public1_subnet.id

  tags = {
    Name = "tf_bastion_host"
  }
}

# Instance - Private
resource "aws_instance" "tf_pri_instance" {
  ami                    = var.amis[var.aws_region]
  instance_type          = var.instance_type
  key_name               = aws_key_pair.tf_auth.id
  vpc_security_group_ids = [aws_security_group.tf_pri_sg.id]
  subnet_id              = aws_subnet.tf_private1_subnet.id

  tags = {
    Name = "tf_private1"
  }
}

# Elastic IP
resource "aws_eip" "tf_dev_ip" {
  vpc      = true
  instance = aws_instance.tf_dev_instance.id
}
