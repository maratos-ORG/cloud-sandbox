variable "consul_api" {
  type    = list(string)
  default = []
}


variable "consul" {
  type    = list(string)
  default = []
}

variable "consul_sg" {
  type    = list(string)
  default = []
}

variable "consul_client" {
  type    = list(string)
  default = []
}

variable "consul_client_sg" {
  type    = list(string)
  default = []
}


locals {
  consul_cidr_api = var.add_mask ? [for ip in var.consul_api : contains(split("", ip), "/") ? ip : format("%s/32", ip)] : var.consul_api
  consul_api = flatten([
    for cidr in local.consul_cidr_api : [
      {
        proto       = "tcp"
        type        = "ingress"
        port_range  = "8501/8501"
        cidr_ip     = cidr
        policy      = "accept"
        description = "Consul API/HTTPS"
      }
    ]
  ])

  consul_cidr = var.add_mask ? [for ip in var.consul : contains(split("", ip), "/") ? ip : format("%s/32", ip)] : var.consul
  consul = flatten([
    for cidr in local.consul_cidr : [
      {
        proto       = "tcp"
        type        = "ingress"
        port_range  = "8300/8300"
        cidr_ip     = cidr
        policy      = "accept"
        description = "Accept inbound Consul RPC traffic from ${cidr}"
      },
      {
        proto       = "tcp"
        type        = "ingress"
        port_range  = "8301/8301"
        cidr_ip     = cidr
        policy      = "accept"
        description = "Accept inbound Consul Serf traffic from ${cidr}"
      },
      {
        proto       = "udp"
        type        = "ingress"
        port_range  = "8301/8301"
        cidr_ip     = cidr
        policy      = "accept"
        description = "Accept inbound Consul Serf traffic from ${cidr}"
      }
    ]
  ])
  consul_sg = flatten([
    for sg in var.consul_sg : [
      {
        proto                    = "tcp"
        type                     = "ingress"
        port_range               = "8300/8300"
        source_security_group_id = sg
        policy                   = "accept"
        description              = "Accept inbound Consul RPC traffic from ${sg}"
      },
      {
        proto                    = "tcp"
        type                     = "ingress"
        port_range               = "8301/8301"
        source_security_group_id = sg
        policy                   = "accept"
        description              = "Accept inbound Consul Serf traffic from ${sg}"
      },
      {
        proto                    = "udp"
        type                     = "ingress"
        port_range               = "8301/8301"
        source_security_group_id = sg
        policy                   = "accept"
        description              = "Accept inbound Consul Serf traffic from ${sg}"
      }
    ]
  ])

  consul_client_cidr = var.add_mask ? [for ip in var.consul_client : contains(split("", ip), "/") ? ip : format("%s/32", ip)] : var.consul_client
  consul_client = flatten([
    for cidr in local.consul_client_cidr : [
      {
        proto       = "tcp"
        type        = "ingress"
        port_range  = "8301/8301"
        cidr_ip     = cidr
        policy      = "accept"
        description = "Accept inbound Consul Serf traffic from ${cidr}"
      },
      {
        proto       = "udp"
        type        = "ingress"
        port_range  = "8301/8301"
        cidr_ip     = cidr
        policy      = "accept"
        description = "Accept inbound Consul Serf traffic from ${cidr}"
      }
    ]
  ])
  consul_client_sg = flatten([
    for sg in var.consul_client_sg : [
      {
        proto                    = "tcp"
        type                     = "ingress"
        port_range               = "8301/8301"
        source_security_group_id = sg
        policy                   = "accept"
        description              = "Accept inbound Consul Serf traffic from ${sg}"
      },
      {
        proto                    = "udp"
        type                     = "ingress"
        port_range               = "8301/8301"
        source_security_group_id = sg
        policy                   = "accept"
        description              = "Accept inbound Consul Serf traffic from ${sg}"
      }
    ]
  ])
}
