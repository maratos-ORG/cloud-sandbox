This TF code create 
- VPC (if default VPC not set)
- Subnets 
- Parameter Group
- DB Subnet Group 
- RDS Multi-az instance 

```bash
### Go to yours project folder and execute the fellowing cmd
### Change 
- subnet_cidrs, vpc_cidr, location_name and Tags in rds.tf to yours
- backend "s3" in providers.tf

```bash
cd /env/staging/marat/maratos_cluster1  
terraform init 
terraform validate      (Optional)
terraform fmt -check    (Optional)
terraform plan
terraform apply

terraform destroy
```


## How connect to DB
```bash
export DB_HOSTNAME=$(aws rds describe-db-instances \
    --db-instance-identifier maratos-aws-cluster2-stg-rds-db \
    --query 'DBInstances[0].Endpoint.Address' \
    --output text \
    --region eu-central-1)

export DB_USERNAME="newsuper"

#after creating DB cvhange password!!!
psql -h $DB_HOSTNAME -U newsuper -d testdb -p password
ALTER USER newsuper WITH PASSWORD 'SomeNewSecurePassword';

```
