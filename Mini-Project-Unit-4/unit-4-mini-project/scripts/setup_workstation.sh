#!/usr/bin/env bash
# ==============================================================================
# Enterprise Smart Library Management Platform
# Chapter 2: Automated Workstation Baseline & Toolchain Installation
# Target Platform: Ubuntu 22.04 LTS / macOS / WSL2
# Student: Bhagwat Dhonde (PRN: 2125UMLM1015)
# ==============================================================================

set -euo pipefail

echo "=========================================================="
echo " 1. Installing Baseline Workstation Utilities"
echo "=========================================================="
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y \
  curl wget unzip jq git software-properties-common \
  ca-certificates gnupg apt-transport-https \
  python3 python3-pip python3-venv

echo "=========================================================="
echo " 2. Installing AWS Command Line Interface (AWS CLI v2)"
echo "=========================================================="
if ! command -v aws >/dev/null 2>&1; then
  cd /tmp
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip -q awscliv2.zip
  sudo ./aws/install --update
  rm -rf aws awscliv2.zip
  cd -
fi
aws --version

echo "=========================================================="
echo " 3. Installing HashiCorp Terraform CLI (v1.7+)"
echo "=========================================================="
if ! command -v terraform >/dev/null 2>&1; then
  wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt-get update
  sudo apt-get install -y terraform
  terraform -install-autocomplete || true
fi
terraform -version

echo "=========================================================="
echo " 4. Installing Ansible Core & Galaxy Collections"
echo "=========================================================="
if ! command -v ansible >/dev/null 2>&1; then
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt-get install -y ansible
fi
ansible-galaxy collection install amazon.aws community.general community.docker || true
ansible --version

echo "=========================================================="
echo " 5. Generating 4096-bit RSA SSH Key Pair & AWS Import"
echo "=========================================================="
mkdir -p ~/.ssh
KEY_PATH="$HOME/.ssh/library-aws-key"

if [ ! -f "$KEY_PATH" ]; then
  ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N "" -C "devops@careertiq-library"
  chmod 400 "$KEY_PATH"
  chmod 644 "${KEY_PATH}.pub"
  echo "Generated new key pair at $KEY_PATH"
else
  echo "Key pair already exists at $KEY_PATH"
fi

# Import into AWS EC2 if AWS CLI configured
if aws sts get-caller-identity >/dev/null 2>&1; then
  echo "Importing public key into AWS EC2 in region us-east-1..."
  aws ec2 import-key-pair \
    --key-name "library-aws-key" \
    --public-key-material "fileb://${KEY_PATH}.pub" \
    --region us-east-1 || echo "Key already imported in AWS"
fi

echo "=========================================================="
echo " Workstation setup complete! Ready for Terraform & Ansible"
echo "=========================================================="
