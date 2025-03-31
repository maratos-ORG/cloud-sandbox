resource "google_compute_network" "network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false

}


resource "google_compute_subnetwork" "subnets" {
  # checkov:skip=CKV_GCP_26:flow logs will be enabled later
  count = length(var.subnet_cidrs)

  network       = google_compute_network.network.id
  name          = length(var.subnet_names) > count.index ? var.subnet_names[count.index] : "${var.vpc_name}-${count.index}"
  ip_cidr_range = var.subnet_cidrs[count.index]

}

resource "google_compute_firewall" "ingress_deny" {

  network     = google_compute_network.network.id
  name        = "${var.vpc_name}-deny-all-ingress"
  description = "Deny all ingress traffic by default"

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]

  direction = "INGRESS"
  priority  = 65535
}

resource "google_compute_firewall" "egress_deny" {

  network     = google_compute_network.network.id
  name        = "${var.vpc_name}-drop-all-egress"
  description = "Deny all egress traffic by default"

  deny {
    protocol = "all"
  }

  direction = "EGRESS"
  priority  = 65535
}
