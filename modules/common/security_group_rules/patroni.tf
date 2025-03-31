locals {
  patroni_cidr = var.add_mask ? [for ip in var.patroni : contains(split("", ip), "/") ? ip : format("%s/32", ip)] : var.patroni
  patroni = [
    for cidr in local.patroni_cidr :
    {
      proto       = "tcp"
      type        = "ingress"
      port_range  = "8008/8008"
      cidr_ip     = cidr
      policy      = "accept"
      description = "Accept inbound Patroni interconnect traffic from ${cidr}"
    }
  ]
  patroni_sg = [
    for sg in var.patroni_sg :
    {
      proto                    = "tcp"
      type                     = "ingress"
      port_range               = "8008/8008"
      source_security_group_id = sg
      policy                   = "accept"
      description              = "Accept inbound Patroni interconnect traffic from ${sg}"
    }
  ]

}
