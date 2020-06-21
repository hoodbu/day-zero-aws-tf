provider "aws" {
  profile    = "default"
  region     = var.region
}

resource "aws_instance" "example" {
  ami           = var.amis[var.region]
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  vpc_security_group_ids=["sg-06f7d42f923804e56"]
  subnet_id="subnet-0d5dfc3739ac57429"
}

resource "aws_eip" "ip" {
    vpc = true
    instance = aws_instance.example.id
}
