resource "google_compute_router" "router" {
  name    = var.vpc_name
  region  = google_compute_subnetwork.subnets[0].region
  network = google_compute_network.network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_address" "nat" {
  name   = "${var.vpc_name}-nat"
  region = google_compute_subnetwork.subnets[0].region
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.vpc_name}-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = [google_compute_address.nat.self_link]

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
