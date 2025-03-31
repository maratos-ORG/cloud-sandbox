variable "add_mask" {
  type = bool
  default = true
}

variable "http" {
  type    = list(string)
  default = []
}

variable "http_sg" {
  type    = list(string)
  default = []
}

variable "https" {
  type    = list(string)
  default = []
}

variable "https_sg" {
  type    = list(string)
  default = []
}

variable "https_no_sni" {
  type    = list(string)
  default = []
}

variable "https_no_sni_sg" {
  type    = list(string)
  default = []
}

variable "ssh" {
  type    = list(string)
  default = []
}

variable "ssh_sg" {
  type    = list(string)
  default = []
}

variable "smtp" {
  type    = list(string)
  default = []
}

variable "smtp_sg" {
  type    = list(string)
  default = []
}

variable "haproxy_interconnect" {
  type    = list(string)
  default = []
}

variable "haproxy_interconnect_sg" {
  type    = list(string)
  default = []
}

variable "popapi_interconnect" {
  type    = list(string)
  default = []
}

variable "popapi_interconnect_sg" {
  type    = list(string)
  default = []
}

variable "restapi_interconnect" {
  type    = list(string)
  default = []
}

variable "restapi_interconnect_sg" {
  type    = list(string)
  default = []
}

variable "proxy_interconnect" {
  type    = list(string)
  default = []
}

variable "proxy_interconnect_sg" {
  type    = list(string)
  default = []
}

variable "patroni" {
  type    = list(string)
  default = []
}

variable "patroni_sg" {
  type    = list(string)
  default = []
}

variable "postgres" {
  type    = list(string)
  default = []
}

variable "postgres_sg" {
  type    = list(string)
  default = []
}

variable "pgbouncer" {
  type    = list(string)
  default = []
}

variable "pgbouncer_sg" {
  type    = list(string)
  default = []
}

variable "raft" {
  type    = list(string)
  default = []
}

variable "raft_sg" {
  type    = list(string)
  default = []
}
