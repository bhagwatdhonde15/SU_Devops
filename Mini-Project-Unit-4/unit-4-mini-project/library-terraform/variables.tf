# ==============================================================================
# Enterprise Smart Library Management Platform - Input Variables
# Unit 4: Infrastructure Automation
# Student: Bhagwat Dhonde (PRN: 2125UMLM1015)
# ==============================================================================

variable "aws_region" {
  description = "The AWS Region where all resources will be provisioned"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "The project name prefix for resource naming tags"
  type        = string
  default     = "library"
}

variable "environment" {
  description = "Deployment environment identifier (e.g., production, staging, dev)"
  type        = string
  default     = "production"
}

variable "vpc_cidr" {
  description = "CIDR block for the dedicated Smart Library VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public application subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Target Availability Zone for the subnet"
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "EC2 instance compute type for hosting Docker & Nginx"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the EC2 Key Pair imported for SSH access"
  type        = string
  default     = "library-aws-key"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block permitted to establish inbound SSH connections"
  type        = string
  default     = "0.0.0.0/0"
}
