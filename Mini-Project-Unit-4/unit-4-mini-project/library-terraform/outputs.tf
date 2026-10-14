# ==============================================================================
# Enterprise Smart Library Management Platform - Terraform Outputs
# Unit 4: Infrastructure Automation
# Student: Bhagwat Dhonde (PRN: 2125UMLM1015)
# ==============================================================================

output "instance_id" {
  description = "The EC2 Instance ID of the Smart Library host"
  value       = aws_instance.library_server.id
}

output "instance_public_ip" {
  description = "The Public IPv4 address of the Smart Library host (use in Ansible inventory.ini)"
  value       = aws_instance.library_server.public_ip
}

output "instance_public_dns" {
  description = "The Public DNS hostname of the EC2 instance"
  value       = aws_instance.library_server.public_dns
}

output "vpc_id" {
  description = "The ID of the Smart Library VPC"
  value       = aws_vpc.library_vpc.id
}

output "subnet_id" {
  description = "The ID of the Smart Library public subnet"
  value       = aws_subnet.library_subnet.id
}

output "security_group_id" {
  description = "The ID of the Smart Library Security Group"
  value       = aws_security_group.library_sg.id
}

output "s3_backup_bucket_name" {
  description = "The globally unique name of the S3 database backup bucket"
  value       = aws_s3_bucket.library_backup.bucket
}

output "s3_backup_bucket_arn" {
  description = "The ARN of the S3 database backup bucket"
  value       = aws_s3_bucket.library_backup.arn
}

output "ansible_inventory_entry" {
  description = "Formatted entry for immediate copy-paste into Ansible inventory.ini"
  value       = "${aws_instance.library_server.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/library-aws-key"
}
