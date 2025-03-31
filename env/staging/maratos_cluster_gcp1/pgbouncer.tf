locals {
  pgbouncer_instance_name_gcp = "${local.location_name_gcp}-pgbouncer"
}


module "security_group_rules_pgbouncer_gcp" {
  source = "../../../modules/common/security_group_rules"

  ssh = concat(
    # module.deploy_hosts_addr.cidr,
    ["0.0.0.0/0"]
  )
  pgbouncer = concat(
    module.deploy_hosts_addr.cidr,
  )
}

module "pgbouncer_gcp" {
  source                      = "../../../modules/gcp/instance"
  name                        = local.pgbouncer_instance_name_gcp
  number_of_instances         = 3

  associate_eip               = true
  availability_zones          = var.availability_zones_gcp
  instance_type               = "e2-micro"
  security_rules              = module.security_group_rules_pgbouncer_gcp.rules
  subnet_ids                  = module.network_gcp.subnet_ids
  tags                        = var.tags_gcp
  provision_project_ssh_keys  = true
  use_num_suffix              = true  # add number suffix to the instance name. Mandatry if number_of_instances > 1 is used  
  hostname_use_public_ip      = true

  volumes = [
    {
      name          = "data"
      resource_name = "database-disk"
      device_type   = "pd-standard"
      device_size   = 40
    }
  ]
}
