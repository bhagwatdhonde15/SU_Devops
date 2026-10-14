# ==============================================================================
# Enterprise Smart Library Management Platform - Terraform Backend Configuration
# Unit 4: Infrastructure Automation
# Student: Bhagwat Dhonde (PRN: 2125UMLM1015)
# ==============================================================================

# Remote S3 backend with state locking:
# Uncomment the block below when deploying with a pre-created S3 backend bucket and DynamoDB table.
# For initial local bootstrapping or dry-run validation, local state is supported by default.

/*
terraform {
  backend "s3" {
    bucket         = "careertiq-devops-terraform-state"
    key            = "unit-4/smart-library/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true # Modern Terraform v1.7+ state locking parameter
    # dynamodb_table = "terraform-state-lock" # Legacy parameter note from lab manual
  }
}
*/
