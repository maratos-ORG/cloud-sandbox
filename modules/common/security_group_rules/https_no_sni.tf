locals {
  https_no_sni_cidr = var.add_mask ? [for ip in var.https_no_sni : contains(split("", ip), "/") ? ip : format("%s/32", ip)] : var.https_no_sni
  https_no_sni = [
    for cidr in local.https_no_sni_cidr :
    {
      proto       = "tcp"
      type        = "ingress"
      port_range  = "50443/50443"
      cidr_ip     = cidr
      policy      = "accept"
      description = "Accept inbound HTTPS traffic from ${cidr}"
    }
  ]
  https_no_sni_sg = [
    for sg in var.https_no_sni_sg :
    {
      proto                    = "tcp"
      type                     = "ingress"
      port_range               = "50443/50443"
      source_security_group_id = sg
      policy                   = "accept"
      description              = "Accept inbound HTTPS traffic from ${sg}"
    }
  ]

}
