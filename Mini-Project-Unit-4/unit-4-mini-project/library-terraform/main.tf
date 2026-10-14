# ==============================================================================
# Enterprise Smart Library Management Platform - Infrastructure as Code Suite
# Unit 4: Infrastructure Automation
# Student: Bhagwat Dhonde (PRN: 2125UMLM1015)
# ==============================================================================

# Query current AWS Account caller identity for unique naming
data "aws_caller_identity" "current" {}

# Query Canonical Ubuntu 22.04 LTS official latest AMI ID via AWS SSM Parameter Store
data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

# ------------------------------------------------------------------------------
# 1. NETWORKING FABRIC: Dedicated VPC, Subnet, Internet Gateway & Routing
# ------------------------------------------------------------------------------

resource "aws_vpc" "library_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "library_subnet" {
  vpc_id                  = aws_vpc.library_vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-subnet"
  }
}

resource "aws_internet_gateway" "library_igw" {
  vpc_id = aws_vpc.library_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "library_route_table" {
  vpc_id = aws_vpc.library_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.library_igw.id
  }

  tags = {
    Name = "${var.project_name}-route-table"
  }
}

resource "aws_route_table_association" "library_route_table_association" {
  subnet_id      = aws_subnet.library_subnet.id
  route_table_id = aws_route_table.library_route_table.id
}

# ------------------------------------------------------------------------------
# 2. SECURITY GOVERNANCE: Security Group for Application & Management Access
# ------------------------------------------------------------------------------

resource "aws_security_group" "library_sg" {
  name        = "${var.project_name}-sg"
  description = "Security Group allowing inbound SSH (22), HTTP (80), App Port (5000), and all outbound egress"
  vpc_id      = aws_vpc.library_vpc.id

  # Inbound SSH rule (Port 22)
  ingress {
    description = "SSH administrative access from authorized CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # Inbound HTTP rule (Port 80)
  ingress {
    description = "Public HTTP web traffic for Nginx reverse proxy"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound Application rule (Port 5000)
  ingress {
    description = "Direct container testing / Flask API access"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Egress rule (Allow all traffic)
  egress {
    description = "Allow all outbound internet traffic for package installs & S3 backup"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

# ------------------------------------------------------------------------------
# 3. COMPUTE FABRIC: EC2 Instance for Docker & Nginx Deployment
# ------------------------------------------------------------------------------

resource "aws_instance" "library_server" {
  ami                         = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.library_subnet.id
  vpc_security_group_ids      = [aws_security_group.library_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
    tags = {
      Name = "${var.project_name}-root-volume"
    }
  }

  tags = {
    Name = "${var.project_name}-server"
    Role = "ApplicationHost"
  }
}

# ------------------------------------------------------------------------------
# 4. STORAGE FABRIC: Resilient S3 Bucket for Database Backups
# ------------------------------------------------------------------------------

resource "aws_s3_bucket" "library_backup" {
  bucket        = "library-backup-${data.aws_caller_identity.current.account_id}-${var.aws_region}"
  force_destroy = true

  tags = {
    Name        = "${var.project_name}-backup"
    Purpose     = "Automated SQLite Database Backups"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "library_backup_versioning" {
  bucket = aws_s3_bucket.library_backup.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "library_backup_encryption" {
  bucket = aws_s3_bucket.library_backup.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = false
  }
}
