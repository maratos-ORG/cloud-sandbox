locals {
  bkp_instance_name_gcp = "${local.location_name_gcp}-bkp"
}

module "security_group_rules_bkp_gcp" {
  source = "../../../modules/common/security_group_rules"

  ssh = concat(
    # module.deploy_hosts_addr.cidr,
    ["0.0.0.0/0"]
  )
}

module "bkp_gcp" {
  source                      = "../../../modules/gcp/instance"
  name                        = local.bkp_instance_name_gcp
  number_of_instances         = 1

  associate_eip               = false
  availability_zones          = var.availability_zones_gcp
  instance_type               = "e2-micro"
  security_rules              = module.security_group_rules_bkp_gcp.rules
  subnet_ids                  = module.network_gcp.subnet_ids
  tags                        = var.tags_gcp
  provision_project_ssh_keys  = true
  use_num_suffix              = true  # add number suffix to the instance name. Mandatry if number_of_instances > 1 is used  
  hostname_use_public_ip      = true

  volumes = [
    {
      name          = "data"
      resource_name = "database-disk"
      device_type   = "pd-balanced"
      device_size   = 40
    }
  ]
}
