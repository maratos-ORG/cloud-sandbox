module "deploy_hosts_addr" {
  source = "../../../modules/common/deploy_hosts_addr/staging/"
}

module "network_gcp" {
  source       = "../../../modules/gcp/vpc/"
  vpc_name     = local.vpc_name_gcp
  subnet_cidrs = local.vpc_cidr_gcp
  subnet_names = local.subnet_names_gcp
}