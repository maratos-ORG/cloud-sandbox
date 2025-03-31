locals {
  https_cidr = var.add_mask ? [for ip in var.https : contains(split("", ip), "/") ? ip : format("%s/32", ip)] : var.https
  https = [
    for cidr in local.https_cidr :
    {
      proto       = "tcp"
      type        = "ingress"
      port_range  = "443/443"
      cidr_ip     = cidr
      policy      = "accept"
      description = "Accept inbound HTTPS traffic from ${cidr}"
    }
  ]
  https_sg = [
    for sg in var.https_sg :
    {
      proto                    = "tcp"
      type                     = "ingress"
      port_range               = "443/443"
      source_security_group_id = sg
      policy                   = "accept"
      description              = "Accept inbound HTTPS traffic from ${sg}"
    }
  ]

}
