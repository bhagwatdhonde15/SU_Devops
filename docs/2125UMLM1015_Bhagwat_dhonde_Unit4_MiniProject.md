# Academic Project Report: Unit 4 Mini-Project
## Enterprise Smart Library Management Platform: Cloud Infrastructure Automation

---

### Candidate Details
* **Student Name:** Bhagwat Dhonde
* **PRN:** 2125UMLM1015
* **Module:** Unit 4: Infrastructure Automation
* **Target Environment:** AWS Cloud (us-east-1), Ubuntu 22.04 LTS
* **Technologies:** Terraform, Ansible, Docker, Nginx, Python Flask, SQLite, AWS CLI v2, AWS S3

---

### 1. Executive Summary
This project demonstrates an enterprise-grade automated deployment pipeline for the **Enterprise Smart Library Management Platform**. By leveraging Infrastructure as Code (IaC) via HashiCorp Terraform and Configuration Management via Ansible Core, manual provisioning errors are eliminated and an immutable, deterministic infrastructure is realized. 

The application layer consists of a containerized RESTful API running Python Flask with a persistent SQLite database, reverse-proxied by Nginx for high throughput and security. Automated backup procedures ensure point-in-time disaster recovery to an encrypted and versioned Amazon S3 bucket.

---

### 2. Project Objectives
1. **Automated Provisioning:** Declaratively provision a virtual private cloud (VPC), subnet, route tables, internet gateway, security groups, and an EC2 instance using Terraform HCL.
2. **Configuration Automation:** Configure server baselines, security firewall rules, Docker container runtime, and Nginx reverse proxy via modular Ansible roles (`common`, `docker`, `nginx`, `library_app`).
3. **Containerized Microservice:** Package the Smart Library service into a lightweight Docker image with health checks and persistent volume storage.
4. **Resilient Data Governance:** Configure automated backups of the SQLite database to Amazon S3 with AES256 server-side encryption and object versioning.
5. **Quality Verification:** Validate system availability, API contracts (`/`, `/api/health`, `/api/books`), and security posture.

---

### 3. Toolchain & Technologies Used
| Component | Technology | Version | Purpose |
| :--- | :--- | :--- | :--- |
| **Cloud Provider** | Amazon Web Services | AWS CLI v2.15+ | Cloud infrastructure & API interactions |
| **IaC Engine** | HashiCorp Terraform | v1.7+ | Declarative cloud fabric provisioning |
| **Config Management** | Ansible Core | v2.16+ | Agentless server provisioning over OpenSSH |
| **Web Server** | Nginx | 1.18+ | Reverse proxy and edge routing |
| **Container Engine** | Docker CE | 24+ | Application containerization and isolation |
| **Application Layer** | Python Flask | 3.1+ | RESTful microservice API |
| **Database** | SQLite3 | 3.x | Lightweight embedded relational database |
| **Object Storage** | AWS S3 | Standard | Encrypted and versioned disaster recovery backups |

---

### 4. Implementation Steps & Results

#### Step 1: Workstation Setup & Authentication
* Established local packages: `curl`, `jq`, `unzip`, `python3-pip`.
* Generated a 4096-bit RSA SSH key pair (`~/.ssh/library-aws-key`).
* Imported the public key to AWS EC2 as `library-aws-key`.
* Validated credentials using `aws sts get-caller-identity`.

#### Step 2: Terraform Infrastructure Provisioning
* Initialized provider `hashicorp/aws` (~> 5.0).
* Deployed `library_vpc` (10.0.0.0/16), `library_subnet` (10.0.1.0/24), `library_igw`, and `library_route_table`.
* Configured `library_sg` permitting inbound traffic on ports 22 (SSH), 80 (HTTP), and 5000 (App).
* Deployed Ubuntu 22.04 LTS instance `library_server`.
* Provisioned S3 bucket `library-backup-<account_id>-us-east-1` with Versioning and AES256 Server-Side Encryption.

#### Step 3: Ansible Configuration Management
* Executed syntax check: `ansible-playbook -i inventory.ini site.yml --syntax-check`.
* Executed playbook `site.yml` consisting of 20 tasks across 4 roles:
  * `common`: APT package caching, system utilities, UFW firewall rules.
  * `docker`: Installation and service enablement.
  * `nginx`: Reverse proxy configuration forwarding port 80 to 5000.
  * `library_app`: Container image build, volume mounts, and container health verification.
* Play recap completed with `ok=20, changed=0, failed=0`.

#### Step 4: Verification & Disaster Recovery
* Verified root endpoint:
  ```json
  {"application": "Smart Library Management Platform", "status": "running"}
  ```
* Verified health check:
  ```json
  {"status": "healthy"}
  ```
* Verified books catalog:
  ```json
  [{"author": "F. Scott Fitzgerald", "id": 1, "title": "The Great Gatsby"}]
  ```
* Verified S3 bucket versioning (`Status: Enabled`) and encryption (`SSEAlgorithm: AES256`).
* Verified database backup artifact (`library.db`) in S3.

---

### 5. Conclusion
The Unit 4 Mini-Project was executed in strict conformance with production DevOps engineering principles. The automation suite provides a repeatable, self-healing, and secure cloud deployment for the Enterprise Smart Library Management Platform.
