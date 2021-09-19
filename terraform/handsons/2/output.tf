output "tf-example-public_ip" {
  value = aws_instance.tf-ec2.public_ip
}

output "tf-example-private-ip" {
  value = aws_instance.tf-ec2.private_ip
}

# output "bucket-names" {
#   value = aws_s3_bucket.tf-s3[*]
# }

output "uppercase_users" {
	value = [for user in var.users : upper(user) if length (user) > 6]
}