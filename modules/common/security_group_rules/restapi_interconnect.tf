locals {
  restapi_interconnect_cidr = var.add_mask ? [for ip in var.restapi_interconnect : contains(split("", ip), "/") ? ip : format("%s/32", ip)] : var.restapi_interconnect
  restapi_interconnect = [
    for cidr in local.restapi_interconnect_cidr :
    {
      proto       = "tcp"
      type        = "ingress"
      port_range  = "9443/9443"
      cidr_ip     = cidr
      policy      = "accept"
      description = "Accept inbound restapi interconnect traffic from ${cidr}"
    }
  ]
  restapi_interconnect_sg = [
    for sg in var.restapi_interconnect_sg :
    {
      proto                    = "tcp"
      type                     = "ingress"
      port_range               = "9443/9443"
      source_security_group_id = sg
      policy                   = "accept"
      description              = "Accept inbound restapi interconnect traffic from ${sg}"
    }
  ]

}
