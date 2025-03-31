locals {
  raft_cidr = var.add_mask ? [for ip in var.raft : contains(split("", ip), "/") ? ip : format("%s/32", ip)] : var.raft
  raft = [
    for cidr in local.raft_cidr :
    {
      proto       = "tcp"
      type        = "ingress"
      port_range  = "3025/3025"
      cidr_ip     = cidr
      policy      = "accept"
      description = "Accept RAFT traffic from ${cidr}"
    }
  ]
  raft_sg = [
    for sg in var.raft_sg :
    {
      proto                    = "tcp"
      type                     = "ingress"
      port_range               = "3025/3025"
      source_security_group_id = sg
      policy                   = "accept"
      description              = "Accept RAFT traffic from ${sg}"
    }
  ]
}
