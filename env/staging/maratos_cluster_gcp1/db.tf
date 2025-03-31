locals {
  # Define the database instance name in GCP
  db_instance_name_gcp = "${local.location_name_gcp}-db"
}

# Module responsible for configuring security group rules (firewall rules) for the database
module "security_group_rules_db_gcp" {
  source = "../../../modules/common/security_group_rules"

  # Allowed SSH access:
  # - "0.0.0.0/0" allows access from anywhere 
  ssh = concat(
    # module.deploy_hosts_addr.cidr,
    ["0.0.0.0/0"]
  )
  # Allowed access to PostgreSQL:
  # This section defines which instances are allowed to access the database instances deployed in `module "db_gcp"`  
  postgres = concat(
    module.db_gcp.instance_private_ips,        
    module.bkp_gcp.instance_private_ips,
    module.pgbouncer_gcp.instance_private_ips,
  )
  # Allowed access to Patroni:
  # Defines instances that can communicate with the Patroni cluster for high availability management.  
  patroni = concat(
    module.db_gcp.instance_private_ips,
  )
}

# Module responsible for deploying database instances in GCP
module "db_gcp" {
  source                     = "../../../modules/gcp/instance"
  name                       = local.db_instance_name_gcp
  number_of_instances        = 2

  associate_eip              = false
  availability_zones         = var.availability_zones_gcp
  instance_type              = "e2-standard-2"
  security_rules             = module.security_group_rules_db_gcp.rules
  subnet_ids                 = module.network_gcp.subnet_ids
  tags                       = var.tags_gcp
  provision_project_ssh_keys = true
  use_num_suffix             = true  # add number suffix to the instance name. Mandatry if number_of_instances > 1 is used  
  hostname_use_public_ip     = true

  # Define storage volumes attached to each database instance
  volumes = [
    {
      name          = "data"
      resource_name = "database-disk"
      device_type   = "pd-ssd"
      device_size   = 40
    },
    {
      name          = "backup"
      resource_name = "backup-disk"
      device_type   = "pd-ssd"
      device_size   = 20
    }
  ]
}
