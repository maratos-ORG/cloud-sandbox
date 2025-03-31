locals {
  haproxy_cidr = var.add_mask ? [for ip in var.haproxy_interconnect : contains(split("", ip), "/") ? ip : format("%s/32", ip)] : var.haproxy_interconnect
  haproxy_interconnect = [
    for cidr in local.haproxy_cidr :
    {
      proto       = "tcp"
      type        = "ingress"
      port_range  = "7443/7443"
      cidr_ip     = cidr
      policy      = "accept"
      description = "Accept inbound haproxy interconnect traffic from ${cidr}"
    }
  ]
  haproxy_interconnect_sg = [
    for sg in var.haproxy_interconnect_sg :
    {
      proto                    = "tcp"
      type                     = "ingress"
      port_range               = "7443/7443"
      source_security_group_id = sg
      policy                   = "accept"
      description              = "Accept inbound haproxy interconnect traffic from ${sg}"
    }
  ]

}
