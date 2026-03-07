This README is designed to look professional for the UK 2026 job market. It focuses on **Infrastructure as Code (IaC)**, **Security**, and **Problem-Solving**, which are the top priorities for hiring managers.

---

# ☁️ AWS Cloud-Native Node.js Pipeline (ECS & Terraform)

## 📌 Project Overview

This project demonstrates a fully automated, production-grade deployment of a containerized Node.js application. Instead of manual configuration, the entire infrastructure—including networking, security, and orchestration—is managed as code.

The core philosophy of this repository is **"Security-First"**: it utilizes **OpenID Connect (OIDC)** to allow GitHub Actions to communicate with AWS without the need for long-lived, high-risk Access Keys.

---

## 🏗️ Architecture

The infrastructure is designed for high availability and serverless execution:

* **Networking:** Custom VPC with Public Subnets, Internet Gateway, and Route Tables.
* **Orchestration:** **Amazon ECS (Fargate)** for serverless container management.
* **Registry:** **Amazon ECR** for private Docker image storage.
* **Security:** IAM Roles with Least-Privilege policies and OIDC Identity Federation.

---

## 🚀 The CI/CD Pipeline

The workflow is triggered on every push to the `master` branch:

1. **Lint & Validate:** Ensures Terraform code is syntactically correct.
2. **Infrastructure Sync:** Terraform matches the AWS environment to the code.
3. **Build & Push:** GitHub Actions builds the Docker image and tags it with the commit SHA.
4. **Deploy:** The ECS Service is updated with the new image definition, triggering a rolling update with zero downtime.

---

## 🛠️ Lessons from the "Real World"

This project wasn't a "happy path" tutorial. During development, I successfully navigated and documented the following production-level challenges:

* **State Version Conflict:** Resolved an `unsupported backend state version 4` error by performing a CLI upgrade to v1.14.6 and re-synchronizing the remote state provider.
* **IAM Entity Collisions:** Managed race conditions where manual resource deletions left orphaned IAM roles. Resolved by implementing strict dependency mapping in Terraform.
* **Git Disaster Recovery:** Utilized `git reflog` and `hard resets` to recover infrastructure configurations after a corrupted local state.

---

## 🔧 Installation & Usage

### 1. Prerequisites

* AWS CLI & Terraform (v1.14.6) installed.
* GitHub Repository Secrets configured (`AWS_ROLE_ARN`).

### 2. Local Setup

```bash
git clone https://github.com/your-username/your-repo-name.git
cd terraform
terraform init

```

### 3. Deployment

I have included a **Makefile** to streamline operations:

* `make plan` : Preview infrastructure changes.
* `make apply`: Deploy the full stack to AWS.
* `make nuke` : Safely destroy all resources to prevent unnecessary AWS costs.

---

## 📂 Project Structure

```text
.
├── .github/workflows/    # CI/CD pipeline definitions
├── app/                  # Node.js source code & Dockerfile
├── terraform/            # IaC files (VPC, ECS, ECR, IAM)
├── Makefile              # Automation shortcuts
└── README.md             # Project documentation

```

---

## 👤 Author

**Your Name**

* **LinkedIn**: [linkedin.com/in/yourprofile](https://linkedin.com/in/yourprofile)
* **Portfolio**: [yourportfolio.com](https://www.google.com/search?q=https://yourportfolio.com)

---

### Pro-Tip:

Since you aren't keeping the project live to save costs, I highly recommend adding a folder called `assets/` in your repo and putting your **successful build screenshots** and **ECS Running Task** screenshots there. You can then reference them in this README like this:
`![ECS Success](./assets/ecs_success.png)`

**Would you like me to help you write the "Technical Challenges" section in more detail to highlight your troubleshooting skills even further?**