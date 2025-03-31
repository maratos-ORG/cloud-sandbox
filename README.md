# Terraform Sandboxes for DBAs (AWS + GCP)

This repository contains cloud sandbox environments for PostgreSQL DBAs to experiment and test infrastructure on both AWS and GCP.

## ☁️ Platforms

- [AWS Sandbox](./README-aws.md): RDS, VPCs, and networking playground
- [GCP Sandbox](./README-gcp.md): Compute instances

---

## 📁 Directory Structure

All environments and user-specific projects live under **env/staging/<your_project>/**
You are free to create your own folders there and structure your project as needed.

---

## 🌍 Terraform State Management

Each project **must use separate remote state storage**.
🟡 AWS Example

```hcl
terraform {
  backend "s3" {
    bucket         = "maratos-state-aws-dba-sandbox"
    key            = "terraform-state/env/staging/USER/PROJECT_NAME/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = false
    dynamodb_table = "terraform-locks-TABLE_FOR_USER"
  }
}
```

🔵 GCP Example
```hcl
terraform {
  backend "gcs" {
    bucket = "14c12ce0ade03cef-terraform-remote-backend"
    prefix = "staging/maratos_cluster1/terraform.tfstate"  # Change this per environment
  }
}
```

You can use Terraform Cloud, AWS, GCS, or local state (for experimentation), but don’t forget to isolate states between projects.

---

## VPC & Subnet Guidelines
We can use the default VPC or create a separate one for testing, but if anyone needs more, they can create their own VPC and subnets. To avoid confusion, I suggest distributing the networks among the users as follows:
- marat_bogatyrev : 10.100.0.0  - 10.100.15.255 (10.100.0.0/20)
- user1           : 10.100.16.0 - 10.100.31.255 (10.100.16.0/20)
- user2           : 10.100.32.0 - 10.100.47.255 (10.100.32.0/20)