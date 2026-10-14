# Unit 4: Infrastructure Automation Mini-Project
## Enterprise Smart Library Management Platform

### Candidate Information
* **Student Name:** Bhagwat Dhonde
* **PRN:** 2125UMLM1015
* **Module:** Unit 4: Infrastructure Automation
* **Curriculum:** CAREERTIQ Cloud DevOps Engineering Series

---

## Overview

This directory contains the complete source code, Infrastructure as Code (Terraform), Configuration Management (Ansible), and containerized microservice (Docker & Nginx) for the **Enterprise Smart Library Management Platform**.

### Directory Structure

* **[`unit-4-mini-project/`](./unit-4-mini-project/):** Complete production automation suite.
  * **[`library-terraform/`](./unit-4-mini-project/library-terraform/):** AWS cloud fabric provisioning (VPC, Subnet, Route Table, IGW, Security Group, EC2 host, and S3 backup bucket).
  * **[`library-ansible/`](./unit-4-mini-project/library-ansible/):** Server baseline, Docker runtime, Nginx reverse proxy, and microservice container deployment (20-task playbook).
  * **[`library-app/`](./unit-4-mini-project/library-app/):** RESTful Python Flask API with automated SQLite database seeding (`library.db`).
  * **[`scripts/`](./unit-4-mini-project/scripts/):** Workstation setup, end-to-end deployment, API testing, and S3 backup verification scripts.
  * **[`docs/`](./unit-4-mini-project/docs/):** Architecture diagrams, laboratory walkthrough manual, and academic project submission report.

For full setup and execution instructions, please refer to the detailed [unit-4-mini-project README](./unit-4-mini-project/README.md).
