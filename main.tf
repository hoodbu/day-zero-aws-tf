provider "aws" {
  profile    = "default"
  region     = var.aws_region
}

resource "aws_instance" "example" {
  ami           = var.amis[var.aws_region]
  instance_type = "t2.micro"
  vpc_security_group_ids=["sg-06f7d42f923804e56"]
  subnet_id="subnet-0d5dfc3739ac57429"
  tags = {
    Name = "Pakdude Instance"
  }
}

# Networking VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block           = "var.vpc_cidr"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Staging VPC"
  }
}

# Networking IGW
resource "aws_internet_gateway" "tf_igw" {
    vpc_id = "aws_vpc.tf_vpc.id"
    tags = {
      Name = "Staging IGW"
    }
}

# Networking Route Tables
resource "aws_route_table" "tf_public_rt" {
  vpc_id = "aws_vpc.tf_vpc.id"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "aws_internet_gateway.tf_igw.id"
  }
  tags = {
    Name = "tf_public_rt"
  }
}

resource "aws_route_table" "tf_private_rt" {
  vpc_id = "aws_vpc.tf_vpc.id"
  tags = {
    Name = "tf_private_rt"
  }
}

# Networking Subnets
resource "aws_subnet" "tf_public1_subnet" {
  vpc_id = "aws_vpc.tf_vpc.id"
  cidr_block = var.aws_cidrs["public1"]
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "tf_public1"
  }
}

resource "aws_subnet" "tf_private1_subnet" {
  vpc_id = "aws_vpc.tf_vpc.id"
  cidr_block = var.aws_cidrs["private1"]
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "tf_private1"
  }
}

# Networking Subnet Associations
resource "aws_route_table_association" "tf_public1_association" {
  subnet_id = "aws_subnet.tf_public1_subnet.id"
  route_table_id = "aws_route_table.tf_public_rt.id"
}

resource "aws_route_table_association" "tf_private1_association" {
  subnet_id = "aws_subnet.tf_private1_subnet.id"
  route_table_id = "aws_default_route_table.tf_private_rt.id"
}
