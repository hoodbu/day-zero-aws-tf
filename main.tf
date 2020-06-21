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

# Networking

resource "aws_vpc" "tf_vpc" {
    cidr_block           = "var.vpc_cidr"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
        Name = "Staging VPC"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "aws_vpc.tf_vpc.id"
    tags = {
        Name = "Staging IGW"
    }
}

resource "aws_eip" "ip" {
    vpc = true
    instance = aws_instance.example.id
}
