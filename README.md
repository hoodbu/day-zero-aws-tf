# terraform-aws-primer
Terraform Primer creates the following resources in AWS:
1. One (1) VPC in region defined in aws_region variable. All subsequent resources created in that.
2. One (1) Public Route Table
3. One (1) Private Route Table
4. One (1) Public Subnet associated with Public route table
5. One (1) Private Subnet associated with Private route table
6. One (1) Internet Gateway attached to VPC
7. One (1) SSH Keypair for EC2 instances
8. One (1) t2.micro EC2 instance in Public Subnet
9. One (1) Security Group allowing SSH access from localip variable. Assigned to Instance in Public Subnet
10. One (1) Elastic IP address allocated to instance in Public Subnet
11. One (1) t2.micro EC2 instance in Private Subnet
12. One (1) Security Group allowing SSH access from aws_vpc_cidr variable. Assigned to Instance in Private Subnet