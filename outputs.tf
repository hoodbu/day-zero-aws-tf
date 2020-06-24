output aws-account {
  value       = data.aws_caller_identity.current.account_id
  description = "AWS account Id"
}

output "tf_vpc" {
  value = aws_vpc.tf_vpc.id
}

output "tf_dev_ip" {
  value = aws_eip.tf_dev_ip.public_ip
}