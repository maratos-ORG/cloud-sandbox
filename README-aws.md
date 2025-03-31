# AWS Sandbox for DBAs (RDS Playground)

## Authentication & Console Access 

use [AWS Cloud console](https://maratos.awsapps.com/start). You can access web console from where or get Access keys for *aws cli* and terraform/tofu

Run Terraform
```bash 
# WARNING: change bucket, key, and table name in backend config!
terraform init
terraform plan
terraform apply
terraform destroy
```
Example backend config:
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

## What This Terraform Code Can Deploy

You can use this environment to provision:
- RDS PostgreSQL instances
  - Multi-AZ instance
  - Multi-AZ cluster
  - Read-replica
  - Cross-region replica
- VPCs and subnets
- Security groups

## VPC & Subnet Guidelines
We can use the default VPC or create a separate one for testing, but if anyone needs more, they can create their own VPC and subnets. To avoid confusion, I suggest distributing the networks among the users as follows:
- marat_bogatyrev : 10.100.0.0  - 10.100.15.255 (10.100.0.0/20)
- user1           : 10.100.16.0 - 10.100.31.255 (10.100.16.0/20)
- user2           : 10.100.32.0 - 10.100.47.255 (10.100.32.0/20)