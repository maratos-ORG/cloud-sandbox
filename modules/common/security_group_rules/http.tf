locals {
  http_cidr = var.add_mask ? [for ip in var.http : contains(split("", ip), "/") ? ip : format("%s/32", ip)] : var.http
  http = [
    for cidr in local.http_cidr :
    {
      proto       = "tcp"
      type        = "ingress"
      port_range  = "80/80"
      cidr_ip     = cidr
      policy      = "accept"
      description = "Accept inbound HTTP traffic from ${cidr}"
    }
  ]
  http_sg = [
    for sg in var.http_sg :
    {
      proto                    = "tcp"
      type                     = "ingress"
      port_range               = "80/80"
      source_security_group_id = sg
      policy                   = "accept"
      description              = "Accept inbound HTTP traffic from ${sg}"
    }
  ]

}
