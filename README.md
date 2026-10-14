# SU-DevOps

## Enterprise DevOps & Cloud Engineering Portfolio

### Student Details
- **Name:** Bhagwat Dhonde
- **PRN:** 2125UMLM1015

---

## Curriculum Modules & Mini-Projects

### 1. Unit 1: Operating Systems & System Engineering
- **Documentation:** [`docs/2125UMLM1015_Bhagwat_dhonde_Unit1_MiniProject.docx`](./docs/2125UMLM1015_Bhagwat_dhonde_Unit1_MiniProject.docx)
- **Scope:** Linux process management, bash shell scripting, system utilities, and virtualization.

### 2. Unit 2: Agile Project Management & Scrum
- **Documentation:** [`docs/Unit-2-Agile-Mini-Project_2125UMLM1015_Bhagwatdhonde.docx`](./docs/Unit-2-Agile-Mini-Project_2125UMLM1015_Bhagwatdhonde.docx)
- **Scope:** Agile methodology, sprint planning, user stories, product backlogs, and Scrum ceremonies.

### 3. Unit 3: CI/CD Automation & Kubernetes Orchestration
- **Directory:** [`Mini-Project-Unit-3/`](./Mini-Project-Unit-3/)
- **Core Subdirectory:** [`Mini-Project-Unit-3/Mini-Project-Unit-3-Devops-main/`](./Mini-Project-Unit-3/Mini-Project-Unit-3-Devops-main/)
- **Platform:** Enterprise Student Record and Academic Management Platform
- **Scope:** Jenkins CI/CD pipeline (`Jenkinsfile`), Docker containerization (`Dockerfile`), Kubernetes deployments & services (`k8s/`), and automated testing suites.

### 4. Unit 4: Infrastructure Automation as Code
- **Directory:** [`Mini-Project-Unit-4/`](./Mini-Project-Unit-4/)
- **Core Subdirectory:** [`Mini-Project-Unit-4/unit-4-mini-project/`](./Mini-Project-Unit-4/unit-4-mini-project/)
- **Documentation:** [`docs/2125UMLM1015_Bhagwat_dhonde_Unit4_MiniProject.pdf`](./docs/2125UMLM1015_Bhagwat_dhonde_Unit4_MiniProject.pdf) | [`docs/2125UMLM1015_Bhagwat_dhonde_Unit4_MiniProject.md`](./docs/2125UMLM1015_Bhagwat_dhonde_Unit4_MiniProject.md)
- **Platform:** Enterprise Smart Library Management Platform
- **Scope:** 
  - **HashiCorp Terraform:** Declarative AWS infrastructure provisioning (VPC, Subnet, IGW, Route Table, Security Group, EC2 host, S3 backup bucket).
  - **Ansible Core:** Configuration management playbook (`site.yml`) with 20 tasks across `common`, `docker`, `nginx`, and `library_app` roles.
  - **Application Container:** Python Flask microservice reverse-proxied by Nginx with persistent SQLite storage.
  - **Disaster Recovery:** Automated database backups to Amazon S3 with AES256 server-side encryption and object versioning.

---

## Repository Structure

```text
SU_Devops/
├── docs/                                                 # Academic reports and project documentation
│   ├── 2125UMLM1015_Bhagwat_dhonde_Unit1_MiniProject.docx
│   ├── Unit-2-Agile-Mini-Project_2125UMLM1015_Bhagwatdhonde.docx
│   ├── 2125UMLM1015_Bhagwat_dhonde_Unit4_MiniProject.pdf
│   └── 2125UMLM1015_Bhagwat_dhonde_Unit4_MiniProject.md
│
├── Mini-Project-Unit-3/                                  # Unit 3 Mini Project
│   └── Mini-Project-Unit-3-Devops-main/
│       ├── app/
│       ├── database/
│       ├── k8s/
│       ├── tests/
│       ├── Dockerfile
│       ├── Jenkinsfile
│       ├── README.md
│       ├── requirements.txt
│       └── run.py
│
├── Mini-Project-Unit-4/                                  # Unit 4 Mini Project
│   ├── README.md
│   └── unit-4-mini-project/
│       ├── library-terraform/                            # Terraform AWS IaC Suite
│       ├── library-ansible/                              # Ansible configuration roles & playbook
│       ├── library-app/                                  # Flask REST API microservice
│       ├── scripts/                                      # Deployment, verification & backup scripts
│       ├── docs/                                         # Architecture and walkthrough runbooks
│       ├── .gitignore
│       └── README.md
│
└── README.md                                             # Portfolio Overview
```
