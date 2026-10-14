# ==============================================================================
# Enterprise Smart Library Management Platform - Terraform Providers
# Unit 4: Infrastructure Automation
# Student: Bhagwat Dhonde (PRN: 2125UMLM1015)
# ==============================================================================

terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Smart Library Management Platform"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "Bhagwat Dhonde"
      Unit        = "Unit-4"
    }
  }
}
