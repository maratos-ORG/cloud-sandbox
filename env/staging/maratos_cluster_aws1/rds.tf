locals {
  vpc_id        = null # or default "vpc-0cb768ad3df7ca69f"
  location_name = "maratos-aws-cluster2"
  enable_public_access = true
  env_name = {
    short = "stg"
    full  = "staging"
  }
  tags = {
    Project       = local.location_name
    Team          = "DBA"
    Owner         = "Marat Bogatyrev"
    Environment   = local.env_name["full"]
    Region        = "EMEA"
    ProvisionedBy = "Terraform"
  }
}

module "jump_hosts_addr" {
  source = "../../../modules/jump_hosts_addr/staging/"
}

module "vpc_rds" {
  source                = "../../../modules/aws/vpc_rds"
  vpc_cidr              = "10.100.0.0/22"
  location_name         = local.location_name
  env_name              = local.env_name
  availability_zones    = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  tags                  = local.tags
  vpc_id                = local.vpc_id
  subnet_cidrs          = ["10.100.0.0/24", "10.100.1.0/24", "10.100.2.0/24"] ## if null, then subnets will be created automatically with a /28 mask
  enable_public_access  = local.enable_public_access
}

module "portal_rds" {
  source           = "../../../modules/aws/rds"
  name             = "${local.location_name}-${local.env_name["short"]}-rds-db"
  storage_size     = 100
  max_storage_size = 200
  storage_type     = "gp3" ##standart/gp2/gp3/io1
  instance_class   = "db.t4g.xlarge"
  db_name          = "testdb"
  username         = "newsuper"
  vpc_id           = local.vpc_id != null ? local.vpc_id : module.vpc_rds.vpc_id
  # allow_sg_ids               = ["sg-XXXXXXX"] ### must be from same VPC 
  allow_cidrs                = concat(module.jump_hosts_addr.cidr, ["10.8.11.101/32"])
  allow_egress_cidrs         = []
  auto_minor_version_upgrade = false
  enable_public_access       = local.enable_public_access
  deletion_protection        = false
  engine_version             = "16.7"
  is_multi_az                = true
  storage_encrypted          = false
  copy_tags_to_snapshot      = true
  subnet_ids                 = module.vpc_rds.subnet_ids
  subnet_group_name          = "${local.location_name}-${local.env_name["short"]}-subnet-group"
  subnet_group_description   = "database subnet group for ${local.location_name}"
  backup_retention_period    = 3
  skip_final_snapshot        = true
  ca_cert_identifier         = "rds-ca-rsa4096-g1" #rds-ca-rsa2048-g1
  tags                       = local.tags

  parameters = [
    {
      apply_method = "immediate"
      name         = "log_connections"
      value        = "1"
    },
    {
      apply_method = "immediate"
      name         = "log_disconnections"
      value        = "1"
    },
    {
      apply_method = "immediate"
      name         = "log_hostname"
      value        = "1"
    },
    {
      apply_method = "immediate"
      name         = "log_lock_waits"
      value        = "1"
    },
    {
      apply_method = "immediate"
      name         = "log_statement"
      value        = "ddl"
    },
    {
      apply_method = "immediate"
      name         = "log_statement_stats"
      value        = "0"
    },
    {
      apply_method = "immediate"
      name         = "pgaudit.log"
      value        = "write,function,ddl,role"
    },
    {
      apply_method = "immediate"
      name         = "pgaudit.log_level"
      value        = "log"
    },
    {
      apply_method = "immediate"
      name         = "pgaudit.log_parameter"
      value        = "1"
    },
    {
      apply_method = "immediate"
      name         = "pgaudit.log_relation"
      value        = "0"
    },
    {
      apply_method = "immediate"
      name         = "pgaudit.log_statement_once"
      value        = "0"
    },
    {
      apply_method = "immediate"
      name         = "pgaudit.role"
      value        = "rds_pgaudit"
    },
    {
      apply_method = "immediate"
      name         = "rds.force_autovacuum_logging_level"
      value        = "notice"
    },
    {
      apply_method = "pending-reboot"
      name         = "rds.force_ssl"
      value        = "1"
    },
    {
      apply_method = "pending-reboot"
      name         = "rds.logical_replication"
      value        = "1"
    },
    {
      apply_method = "pending-reboot"
      name         = "shared_preload_libraries"
      value        = "pg_stat_statements,pgaudit"
    }
  ]
}
