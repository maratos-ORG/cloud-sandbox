locals {
  smtp_cidr = var.add_mask ? [for ip in var.smtp : contains(split("", ip), "/") ? ip : format("%s/32", ip)] : var.smtp
  smtp = [
    for cidr in local.smtp_cidr :
    {
      proto       = "tcp"
      type        = "ingress"
      port_range  = "587/587"
      cidr_ip     = cidr
      policy      = "accept"
      description = "Accept inbound SMTP traffic from ${cidr}"
    }
  ]
  smtp_sg = [
    for sg in var.smtp_sg :
    {
      proto                    = "tcp"
      type                     = "ingress"
      port_range               = "587/587"
      source_security_group_id = sg
      policy                   = "accept"
      description              = "Accept inbound SMTP traffic from ${sg}"
    }
  ]
}
