provider "aws" {
  profile    = "default"
  region     = var.region
}

resource "aws_instance" "example" {
  ami           = var.amis[var.region]
  instance_type = "t2.micro"
  vpc_security_group_ids=["sg-06f7d42f923804e56"]
  subnet_id="subnet-0d5dfc3739ac57429"
    tags = {
        Name = "Pakdude Instance"
    }
}

resource "aws_vpc" "vpc" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
        Name = "Staging VPC"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "aws_vpc.vpc.id"
    tags = {
        Name = "Staging IGW"
    }
}

resource "aws_eip" "ip" {
    vpc = true
    instance = aws_instance.example.id
}
