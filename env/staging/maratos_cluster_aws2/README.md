
This TF code create 
- VPC (if default VPC not set)
- Subnets 
- Parameter Group
- DB Subnet Group 
- RDS Multi-az instance + read replica + cross region replica 

```bash
### Go to yours project folder and execute the fellowing cmd
### Change subnet_cidrs, vpc_cidr, location_name and Tags in rds.tf to yours.
cd /env/test_env/marat/maratos_cluster3
terraform init 
terraform validate      (Optional)
terraform fmt -check    (Optional)
terraform plan
terraform apply

terraform destroy
```
