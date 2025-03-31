locals {
  popapi_interconnect_cidr = var.add_mask ? [for ip in var.popapi_interconnect : contains(split("", ip), "/") ? ip : format("%s/32", ip)] : var.popapi_interconnect
  popapi_interconnect = [
    for cidr in local.popapi_interconnect_cidr :
    {
      proto       = "tcp"
      type        = "ingress"
      port_range  = "8443/8443"
      cidr_ip     = cidr
      policy      = "accept"
      description = "Accept inbound popapi interconnect traffic from ${cidr}"
    }
  ]
  popapi_interconnect_sg = [
    for sg in var.popapi_interconnect_sg :
    {
      proto                    = "tcp"
      type                     = "ingress"
      port_range               = "8443/8443"
      source_security_group_id = sg
      policy                   = "accept"
      description              = "Accept inbound popapi interconnect traffic from ${sg}"
    }
  ]

}
