locals {
  ssh_cidr = var.add_mask ? [for ip in var.ssh : contains(split("", ip), "/") ? ip : format("%s/32", ip)] : var.ssh
  ssh = [
    for cidr in local.ssh_cidr :
    {
      proto       = "tcp"
      type        = "ingress"
      port_range  = "22/22"
      cidr_ip     = cidr
      policy      = "accept"
      description = "Accept inbound SSH traffic from ${cidr}"
    }
  ]
  ssh_sg = [
    for sg in var.ssh_sg :
    {
      proto                    = "tcp"
      type                     = "ingress"
      port_range               = "22/22"
      source_security_group_id = sg
      policy                   = "accept"
      description              = "Accept inbound SSH traffic from ${sg}"
    }
  ]
}
