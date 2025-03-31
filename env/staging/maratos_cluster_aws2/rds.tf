locals {
  vpc_id        = null # or default "vpc-0cb768ad3df7ca69f"
  location_name = "maratos-aws-cluster2"
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
  source             = "../../../modules/aws/vpc_rds"
  vpc_cidr           = "10.131.0.0/22"
  location_name      = local.location_name
  env_name           = local.env_name
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  tags               = local.tags
  vpc_id             = local.vpc_id
  subnet_cidrs       = ["10.131.0.0/24", "10.131.1.0/24", "10.131.2.0/24"] ## if null, then subnets will be created automatically with a /28 mask
}

module "vpc_rds_cross1" { ##for cros joing replica :) 
  source = "../../../modules/aws/vpc_rds"
  providers = {
    aws = aws.west 
  }
  vpc_cidr           = "10.140.0.0/22"
  location_name      = local.location_name
  env_name           = local.env_name
  availability_zones = ["eu-west-1a"]
  tags               = local.tags
  vpc_id             = local.vpc_id
  subnet_cidrs       = ["10.140.0.0/24"] ## if null then subnetw will create automaticly with mask /28
}


module "portal_rds" {
  source                     = "../../../modules/aws/rds"
  name                       = "${local.location_name}-${local.env_name["short"]}-rds-db"
  storage_size               = 20
  max_storage_size           = 40    
  storage_type               = "gp2" #standart/gp2/gp3/io1
  instance_class             = "db.t4g.micro"
  db_name                    = "testdb"
  username                   = "newsuper"
  # allow_sg_ids               = ["sg-XXXXXXX"] ### must be from same VPC 
  vpc_id                     = local.vpc_id != null ? local.vpc_id : module.vpc_rds.vpc_id
  allow_cidrs                = concat(module.jump_hosts_addr.cidr, ["10.8.11.101/32"])
  allow_egress_cidrs         = []
  auto_minor_version_upgrade = false
  deletion_protection        = false
  engine_version             = "15.8"
  is_multi_az                = false
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
      apply_method = "pending-reboot"
      name         = "shared_preload_libraries"
      value        = "pg_stat_statements"
    }
  ]
}

module "portal_rds_replica_1" {
  depends_on = [module.portal_rds]
  source     = "../../../modules/aws/rds"

  db_replica = {
    is_set       = true
    cross_region = false
    source_db    = module.portal_rds.arn
    kms_key_arn  = "" # Will be used default rds/kms
  }
  name                       = "${local.location_name}-${local.env_name["short"]}-readreplica-1-rds-db"
  storage_size               = 20
  max_storage_size           = 40    
  storage_type               = "gp2" #standart/gp2/gp3/io1
  instance_class             = "db.t4g.micro"
  db_name                    = "testdb"
  username                   = "newsuper"
  vpc_id                     = local.vpc_id != null ? local.vpc_id : module.vpc_rds.vpc_id
  allow_cidrs                = concat(module.jump_hosts_addr.cidr, ["10.8.11.101/32"])
  allow_egress_cidrs         = []
  auto_minor_version_upgrade = false
  deletion_protection        = false
  subnet_group_create        = false  ## We are using the same VPC as the LEADER, so there is no reason to create a new DB security group (but we can).
  engine_version             = "15.8"
  is_multi_az                = false
  storage_encrypted          = false
  copy_tags_to_snapshot      = true
  subnet_ids                 = module.vpc_rds.subnet_ids
  subnet_group_name          = "${local.location_name}-${local.env_name["short"]}-subnet-group"
  subnet_group_description   = "database subnet group for ${local.location_name}-${local.env_name["short"]}-rds-db"
  backup_retention_period    = 0
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
      apply_method = "pending-reboot"
      name         = "shared_preload_libraries"
      value        = "pg_stat_statements"
    }
  ]
}

 
module "portal_rds_replica_cross1" {
  providers = {
    aws = aws.west
  }
  depends_on = [module.portal_rds]
  source = "../../../modules/aws/rds"

  db_replica = {
    is_set                     = true
    cross_region               = true
    source_db                  = module.portal_rds.arn
    kms_key_arn                = "" # Will be used default rds/kms
  }
  name                       = "${local.location_name}-${local.env_name["short"]}-readreplica-cross1-rds-db"
  storage_size               = 20
  max_storage_size           = 40    
  storage_type               = "gp2"  #standart/gp2/gp3/io1
  instance_class             = "db.t4g.micro"
  db_name                    = "testdb"
  username                   = "newsuper"
  vpc_id                     = local.vpc_id != null ? local.vpc_id : module.vpc_rds_cross1.vpc_id
  allow_cidrs                = concat(module.jump_hosts_addr.cidr)
  allow_egress_cidrs         = []
  auto_minor_version_upgrade = false
  deletion_protection        = false
  engine_version             = "15.8"
  is_multi_az                = false
  storage_encrypted          = false
  copy_tags_to_snapshot      = true
  subnet_ids                 = module.vpc_rds_cross1.subnet_ids 
  subnet_group_name          = "${local.location_name}-${local.env_name["short"]}-readreplica-cross1-subnet-group"
  subnet_group_description   = "database subnet group for ${local.location_name}-${local.env_name["short"]}-readreplica-cross1-rds-db"
  backup_retention_period    = 2
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
      apply_method = "pending-reboot"
      name         = "shared_preload_libraries"
      value        = "pg_stat_statements"
    }
  ]
}
