# AWS 2‑Tier VPC Architecture using Terraform

## 📌 Executive Summary
This project provisions a production‑grade 2‑Tier VPC on AWS using **Terraform (IaC)**.  
It enforces strict networking boundaries, eliminates manual errors, and ensures predictable deployments across environments.

---

## 📐 Network & Infrastructure Architecture
- **VPC Block:** `10.0.0.0/16`
- **Public Subnet (`10.0.1.0/24`):** Internet‑facing workloads via IGW.
- **Private Subnet (`10.0.2.0/24`):** Isolated backend/database tier.
- **Traffic Control:** Custom Route Tables + Security Groups (least privilege).

---

## 🎨 Architecture Diagram
![Architecture](https://github.com/user-attachments/assets/789bfac2-dea9-43e6-ae33-cfafe4ae2d88)

**Output Example**
![Output](https://github.com/user-attachments/assets/b36a3e80-9af9-4cec-8406-2db8f7b273e6)

---

## 🛠️ Technology Stack
- **Infrastructure as Code:** Terraform v1.x+
- **Cloud Provider:** AWS
- **Compute:** EC2
- **Networking:** VPC, IGW, Subnets, Route Tables, Security Groups
- **Version Control:** Git

---

## 📦 Provisioned Resources
- 🌐 **Network Layer:** VPC, Subnets, IGW, Route Tables  
- 🛡️ **Security Layer:** Security Groups for SSH/HTTP  
- 💻 **Compute Layer:** EC2 Web + DB instances  

---

## ⚡ Deployment Workflow

### 1. Prerequisites
- Terraform CLI (v1.3.0+)
- AWS CLI (v2.x)
- IAM credentials with admin permissions

### 2. AWS Authentication
```bash
aws configure

**3. Terraform Execution**
bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve

**4. Tear‑down**
bash
terraform destroy -auto-approve

👤 Author
Jain Ulabadeen  
DevOps Engineer
