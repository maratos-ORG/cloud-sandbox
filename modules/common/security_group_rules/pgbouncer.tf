locals {
  pgbouncer_cidr = var.add_mask ? [for ip in var.pgbouncer : contains(split("", ip), "/") ? ip : format("%s/32", ip)] : var.pgbouncer
  pgbouncer = [
    for cidr in local.pgbouncer_cidr :
    {
      proto       = "tcp"
      type        = "ingress"
      port_range  = "6432/6432"
      cidr_ip     = cidr
      policy      = "accept"
      description = "Accept inbound Pgbouncer interconnect traffic from ${cidr}"
    }
  ]
  pgbouncer_sg = [
    for sg in var.pgbouncer_sg :
    {
      proto                    = "tcp"
      type                     = "ingress"
      port_range               = "6432/6432"
      source_security_group_id = sg
      policy                   = "accept"
      description              = "Accept inbound Pgbouncer interconnect traffic from ${sg}"
    }
  ]
}
