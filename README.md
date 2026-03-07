# ☁️ AWS Cloud-Native Node.js Pipeline (ECS & Terraform)

## 📌 Project Overview

This project demonstrates a production-grade deployment of a containerized Node.js application. The entire infrastructure—including networking, security, and orchestration—is managed as code (IaC) using **Terraform**.

A key focus of this project is **Modern Security**: it utilizes **OpenID Connect (OIDC)** to allow GitHub Actions to communicate with AWS securely without using long-lived Access Keys.

---

## 🏗️ Architecture

The infrastructure follows AWS best practices for serverless container orchestration:

* **Networking:** Custom VPC with Public Subnets, Internet Gateway, and Route Tables.
* **Orchestration:** **Amazon ECS (Fargate)** for serverless container management.
* **Registry:** **Amazon ECR** for private Docker image storage.
* **Security:** IAM Roles with Least-Privilege policies and OIDC Identity Federation.

---

## 🚀 CI/CD Workflow

The pipeline is fully automated via GitHub Actions:

1. **Build:** Packages the Node.js application into a Docker image.
2. **Push:** Authenticates via OIDC and pushes the image to Amazon ECR.
3. **Deploy:** Updates the ECS Task Definition and triggers a rolling update to the cluster.

---

## 🛠️ Lessons from the "Real World"

This project reflects real-world troubleshooting and infrastructure lifecycle management. Key challenges overcome include:

* **State Version Management:** Resolved an `unsupported backend state version 4` error by performing a CLI upgrade to v1.14.6 and re-synchronizing the provider state.
* **Infrastructure Recovery:** Utilized `git reflog` and `hard resets` to recover infrastructure configurations after local state corruption.
* **IAM Entity Conflicts:** Debugged and cleared `EntityAlreadyExists` errors by manually reconciling orphaned resources in the AWS Console.

---

## 🔧 Manual Deployment Guide

### 1. Prerequisites

* AWS CLI and Terraform (v1.14.6) installed.
* GitHub Repository Secrets configured (`AWS_ROLE_ARN`).

### 2. Infrastructure Deployment

Navigate to the terraform directory:

```bash
cd terraform

```

Initialize the provider and backend:

```bash
terraform init

```

Preview the resource creation:

```bash
terraform plan

```

Deploy the infrastructure:

```bash
terraform apply -auto-approve

```

### 3. Cleanup (Cost Optimization)

To avoid unnecessary AWS charges, decommission the infrastructure when not in use:

```bash
terraform destroy -auto-approve

```

---

## 📂 Project Structure

```text
.
├── .github/workflows/    # GitHub Actions CI/CD definition
├── app/                  # Node.js source code & Dockerfile
├── terraform/            # IaC files (VPC, ECS, ECR, IAM)
└── README.md             # Project documentation

```

---

## 👤 Author

Mihir Menon

* **LinkedIn**: [linkedin.com/in/mihirmenon](https://linkedin.com/in/mihirmenon)
* **GitHub**: [github.com/mihirxtc](https://github.com/mihirxtc)