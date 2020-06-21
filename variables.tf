variable "aws_region" {
  default = "us-west-1"
}

variable "amis" {
  type = map
  default = {
    "us-east-1" = "ami-b374d5a5"
    "us-west-2" = "ami-4b32be2b"
  }
}

data "aws_availability_zones" "available" {}

# Networking
variable "aws_vpc_cidr" {}

variable "aws_cidrs" {
  type = map
}

variable "localip" {}
