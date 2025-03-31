locals {
  postgres_cidr = var.add_mask ? [for ip in var.postgres : contains(split("", ip), "/") ? ip : format("%s/32", ip)] : var.postgres
  postgres = [
    for cidr in local.postgres_cidr :
    {
      proto       = "tcp"
      type        = "ingress"
      port_range  = "5432/5432"
      cidr_ip     = cidr
      policy      = "accept"
      description = "Accept inbound Postgres interconnect traffic from ${cidr}"
    }
  ]
  postgres_sg = [
    for sg in var.postgres_sg :
    {
      proto                    = "tcp"
      type                     = "ingress"
      port_range               = "5432/5432"
      source_security_group_id = sg
      policy                   = "accept"
      description              = "Accept inbound Postgres interconnect traffic from ${sg}"
    }
  ]
}
