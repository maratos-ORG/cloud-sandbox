output "instances_info" {
  value = {
    db_instance = {
      name         = local.db_instance_name_gcp
      public_ips   = module.db_gcp.instance_public_ips
      private_ips  = module.db_gcp.instance_private_ips
    }
    bkp_instance = {
      name         = local.bkp_instance_name_gcp
      public_ips   = module.bkp_gcp.instance_public_ips
      private_ips  = module.bkp_gcp.instance_private_ips
    }
    pgbouncer_instance = {
      name         = local.pgbouncer_instance_name_gcp
      public_ips   = module.pgbouncer_gcp.instance_public_ips
      private_ips  = module.pgbouncer_gcp.instance_private_ips
    }    
  }
}