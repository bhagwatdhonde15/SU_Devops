# Laboratory Manual Walkthrough & Execution Runbook
## Enterprise Smart Library Management Platform
**Course:** Unit 4: Infrastructure Automation  
**Author:** Bhagwat Dhonde  
**PRN:** 2125UMLM1015  

---

## Chapter 2: Prerequisites & AWS Environment Setup

### 1. Workstation Baseline Utilities
```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y curl wget unzip jq git software-properties-common ca-certificates gnupg apt-transport-https python3 python3-pip python3-venv
```

### 2. Installing AWS CLI v2
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install --update
rm -rf aws awscliv2.zip
aws --version
```

### 3. Installing HashiCorp Terraform CLI
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt-get install -y terraform
terraform -install-autocomplete
terraform -version
```

### 4. Installing Ansible Core & Galaxy Collections
```bash
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible
ansible-galaxy collection install amazon.aws community.general community.docker
ansible --version
```

### 5. Configuring AWS Credentials & STS Check
```bash
aws configure
# Enter Access Key ID, Secret Key, Default region (us-east-1), format (json)

aws sts get-caller-identity
```

### 6. SSH Key Pair Generation & AWS Import
```bash
mkdir -p ~/.ssh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/library-aws-key -N "" -C "devops@careertiq-library"
chmod 400 ~/.ssh/library-aws-key
chmod 644 ~/.ssh/library-aws-key.pub

aws ec2 import-key-pair \
  --key-name "library-aws-key" \
  --public-key-material fileb://~/.ssh/library-aws-key.pub \
  --region us-east-1
```

---

## Chapter 3: Terraform Infrastructure as Code Suite

Navigate to the `library-terraform` folder:
```bash
cd library-terraform
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### Expected Output & State Tracking:
* `data.aws_caller_identity.current`: Resolves AWS Account ID.
* `data.aws_ssm_parameter.ubuntu_ami`: Fetches Ubuntu 22.04 LTS official AMI.
* `aws_vpc.library_vpc`: VPC created with `10.0.0.0/16`.
* `aws_subnet.library_subnet`: Subnet created with `10.0.1.0/24`.
* `aws_internet_gateway.library_igw`: Attached to VPC.
* `aws_route_table.library_route_table`: Outbound route to IGW created.
* `aws_security_group.library_sg`: Inbound 22, 80, 5000 opened.
* `aws_instance.library_server`: EC2 instance running in public subnet.
* `aws_s3_bucket.library_backup`: Versioned and AES256 encrypted bucket provisioned.

---

## Chapter 4: Ansible Configuration Management

Navigate to `library-ansible`:
```bash
cd ../library-ansible

# Verify syntax
ansible-playbook -i inventory.ini site.yml --syntax-check

# Execute playbook
ansible-playbook -i inventory.ini site.yml
```

### Playbook Execution Tasks (Total 20 Tasks):
1. `TASK [Gathering Facts]`
2. `TASK [common : Update apt package cache]`
3. `TASK [common : Install system utilities]`
4. `TASK [common : Allow SSH through UFW]`
5. `TASK [common : Allow HTTP through UFW]`
6. `TASK [common : Allow application port through UFW]`
7. `TASK [docker : Install Docker]`
8. `TASK [docker : Start and enable Docker]`
9. `TASK [nginx : Install Nginx]`
10. `TASK [nginx : Configure Nginx reverse proxy]`
11. `TASK [nginx : Enable library Nginx site]`
12. `TASK [nginx : Remove default Nginx site]`
13. `TASK [nginx : Ensure Nginx is running]`
14. `TASK [library_app : Ensure Docker service is running]`
15. `TASK [library_app : Create application directory]`
16. `TASK [library_app : Copy application files]` (items: `app.py`, `requirements.txt`, `Dockerfile`)
17. `TASK [library_app : Create persistent database directory]`
18. `TASK [library_app : Build library application image]`
19. `TASK [library_app : Run library application container]`
20. `TASK [library_app : Verify library application health]`

**Play Recap:**
```text
PLAY RECAP *********************************************************************
<EC2_IP>                   : ok=20    changed=0    unreachable=0    failed=0
```

---

## Chapter 5: API & S3 Storage Verification

### 1. Curl Endpoints Check
```bash
# Root endpoint
curl http://<EC2_IP>/
# Expected: {"application":"Smart Library Management Platform","status":"running"}

# Health check
curl http://<EC2_IP>/api/health
# Expected: {"status":"healthy"}

# Books list
curl http://<EC2_IP>/api/books
# Expected: [{"author":"F. Scott Fitzgerald","id":1,"title":"The Great Gatsby"}]
```

### 2. S3 Backup & Governance Check
```bash
# Check Versioning
aws s3api get-bucket-versioning \
  --bucket library-backup-<ACCOUNT_ID>-us-east-1 \
  --region us-east-1

# Check Server-Side Encryption
aws s3api get-bucket-encryption \
  --bucket library-backup-<ACCOUNT_ID>-us-east-1 \
  --region us-east-1

# Verify Backup in S3
aws s3 ls s3://library-backup-<ACCOUNT_ID>-us-east-1/backups/ \
  --region us-east-1
```
