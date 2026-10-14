#!/usr/bin/env bash
# ==============================================================================
# Enterprise Smart Library Management Platform - End-to-End Orchestrator
# Unit 4: Infrastructure Automation
# Student: Bhagwat Dhonde (PRN: 2125UMLM1015)
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TERRAFORM_DIR="${PROJECT_ROOT}/library-terraform"
ANSIBLE_DIR="${PROJECT_ROOT}/library-ansible"

echo "=========================================================="
echo " STEP 1: Provisioning Cloud Fabric with Terraform"
echo "=========================================================="
cd "${TERRAFORM_DIR}"
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply -auto-approve tfplan

# Extract provisioned server IP
INSTANCE_IP=$(terraform output -raw instance_public_ip)
BUCKET_NAME=$(terraform output -raw s3_backup_bucket_name)

echo "Provisioned EC2 Host: ${INSTANCE_IP}"
echo "Provisioned S3 Bucket: ${BUCKET_NAME}"

echo "=========================================================="
echo " STEP 2: Updating Ansible Inventory"
echo "=========================================================="
cat <<EOF > "${ANSIBLE_DIR}/inventory.ini"
[smart_library]
${INSTANCE_IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/library-aws-key ansible_python_interpreter=/usr/bin/python3

[smart_library:vars]
app_name=smart-library
app_port=5000
host_app_dir=/opt/library
host_data_dir=/opt/library/data
db_filename=library.db
s3_bucket=${BUCKET_NAME}
EOF

echo "Ansible inventory successfully updated."

echo "Waiting 30 seconds for EC2 instance SSH daemon initialization..."
sleep 30

echo "=========================================================="
echo " STEP 3: Executing Ansible Configuration Management"
echo "=========================================================="
cd "${ANSIBLE_DIR}"
ansible-playbook -i inventory.ini site.yml --syntax-check
ansible-playbook -i inventory.ini site.yml

echo "=========================================================="
echo " STEP 4: Verifying Application Endpoints"
echo "=========================================================="
bash "${SCRIPT_DIR}/test_endpoints.sh" "${INSTANCE_IP}" 80

echo "=========================================================="
echo " STEP 5: Executing S3 Database Backup"
echo "=========================================================="
ssh -o StrictHostKeyChecking=no -i ~/.ssh/library-aws-key ubuntu@"${INSTANCE_IP}" \
  "aws s3 cp /opt/library/data/library.db s3://${BUCKET_NAME}/backups/library.db --sse AES256 --region us-east-1" || true

bash "${SCRIPT_DIR}/verify_backup.sh" us-east-1 || true

echo "=========================================================="
echo " Deployment and Verification Complete!"
echo " Web UI / API: http://${INSTANCE_IP}/"
echo "=========================================================="
