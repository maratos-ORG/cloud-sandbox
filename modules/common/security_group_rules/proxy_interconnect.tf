locals {
  proxy_interconnect_cidr = var.add_mask ? [for ip in var.proxy_interconnect : contains(split("", ip), "/") ? ip : format("%s/32", ip)] : var.proxy_interconnect
  proxy_interconnect = [
    for cidr in local.proxy_interconnect_cidr :
    {
      proto       = "tcp"
      type        = "ingress"
      port_range  = "10443/10443"
      cidr_ip     = cidr
      policy      = "accept"
      description = "Accept inbound proxy interconnect traffic from ${cidr}"
    }
  ]
  proxy_interconnect_sg = [
    for sg in var.proxy_interconnect_sg :
    {
      proto                    = "tcp"
      type                     = "ingress"
      port_range               = "10443/10443"
      source_security_group_id = sg
      policy                   = "accept"
      description              = "Accept inbound proxy interconnect traffic from ${sg}"
    }
  ]

}
