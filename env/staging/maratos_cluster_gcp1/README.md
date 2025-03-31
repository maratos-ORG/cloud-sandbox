
### Login to google and set a proper enviromonts
```bash 
 gcloud auth application-default login
 gcloud projects list
 gcloud config set project dba-test-430310
 gcloud config get-value project
```

## Run Terraform 
```bash 
# WARNING change prefix in backend.tf with yopurs values!
terraform init
terraform plan
terraform apply
terraform destroy
```

## Connect to EC2
```bash 
gcloud compute ssh ec2_name --zone=europe-west1-c -- -A
```

1. This TF code creates:
- 2 DB instance
- 1 backup instance
- 3 pgbouncer instance 

You can use it as a template and create you own set of instances 
```bash
Outputs:

instances_info = {
  "bkp_instance" = {
    "name" = "stg-maratos-01-gcp-bkp"
    "private_ips" = [
      "10.100.0.4",
    ]
    "public_ips" = []
  }
  "db_instance" = {
    "name" = "stg-maratos-01-gcp-db"
    "private_ips" = [
      "10.100.0.3",
      "10.100.0.2",
    ]
    "public_ips" = []
  }
  "pgbouncer_instance" = {
    "name" = "stg-maratos-01-gcp-pgbouncer"
    "private_ips" = [
      "10.100.0.5",
      "10.100.0.6",
      "10.100.0.7",
    ]
    "public_ips" = [
      "35.189.228.213",
      "35.233.72.44",
      "130.211.93.214",
    ]
  }
}
```

2. Set up firewall rules that provide access between instances on particular ports.
```bash
NAME                                         DIRECTION  TARGET_TAGS                       SOURCE_RANGES        ALLOWED                                     DISABLED
stg-maratos-01-gcp-bkp-allow-outbound        EGRESS     ['stg-maratos-01-gcp-bkp']                             [{'IPProtocol': 'all'}]                     False
stg-maratos-01-gcp-bkp-sg-0                  INGRESS    ['stg-maratos-01-gcp-bkp']        ['0.0.0.0/0']        [{'IPProtocol': 'tcp', 'ports': ['22']}]    False
stg-maratos-01-gcp-db-allow-outbound         EGRESS     ['stg-maratos-01-gcp-db']                              [{'IPProtocol': 'all'}]                     False
stg-maratos-01-gcp-db-sg-0                   INGRESS    ['stg-maratos-01-gcp-db']         ['10.100.0.3/32']    [{'IPProtocol': 'tcp', 'ports': ['8008']}]  False
stg-maratos-01-gcp-db-sg-1                   INGRESS    ['stg-maratos-01-gcp-db']         ['10.100.0.2/32']    [{'IPProtocol': 'tcp', 'ports': ['8008']}]  False
stg-maratos-01-gcp-db-sg-2                   INGRESS    ['stg-maratos-01-gcp-db']         ['10.100.0.3/32']    [{'IPProtocol': 'tcp', 'ports': ['5432']}]  False
stg-maratos-01-gcp-db-sg-3                   INGRESS    ['stg-maratos-01-gcp-db']         ['10.100.0.2/32']    [{'IPProtocol': 'tcp', 'ports': ['5432']}]  False
stg-maratos-01-gcp-db-sg-4                   INGRESS    ['stg-maratos-01-gcp-db']         ['10.100.0.4/32']    [{'IPProtocol': 'tcp', 'ports': ['5432']}]  False
stg-maratos-01-gcp-db-sg-5                   INGRESS    ['stg-maratos-01-gcp-db']         ['10.100.0.5/32']    [{'IPProtocol': 'tcp', 'ports': ['5432']}]  False
stg-maratos-01-gcp-db-sg-6                   INGRESS    ['stg-maratos-01-gcp-db']         ['10.100.0.6/32']    [{'IPProtocol': 'tcp', 'ports': ['5432']}]  False
stg-maratos-01-gcp-db-sg-7                   INGRESS    ['stg-maratos-01-gcp-db']         ['10.100.0.7/32']    [{'IPProtocol': 'tcp', 'ports': ['5432']}]  False
stg-maratos-01-gcp-db-sg-8                   INGRESS    ['stg-maratos-01-gcp-db']         ['0.0.0.0/0']        [{'IPProtocol': 'tcp', 'ports': ['22']}]    False
stg-maratos-01-gcp-pgbouncer-allow-outbound  EGRESS     ['stg-maratos-01-gcp-pgbouncer']                       [{'IPProtocol': 'all'}]                     False
stg-maratos-01-gcp-pgbouncer-sg-0            INGRESS    ['stg-maratos-01-gcp-pgbouncer']  ['188.2.97.250/32']  [{'IPProtocol': 'tcp', 'ports': ['6432']}]  False
stg-maratos-01-gcp-pgbouncer-sg-1            INGRESS    ['stg-maratos-01-gcp-pgbouncer']  ['0.0.0.0/0']        [{'IPProtocol': 'tcp', 'ports': ['22']}]    False
```
