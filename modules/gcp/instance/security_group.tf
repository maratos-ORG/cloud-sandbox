locals {
  egress_rule_defined = anytrue([
    for v in var.security_rules :
    lower(lookup(v, "type", "ingress")) == "egress"
  ])
}

resource "google_compute_firewall" "default" {
  count = var.number_of_instances > 0 ? length(var.security_rules) : 0

  network = data.google_compute_subnetwork.subnetwork.network
  name    = lookup(var.security_rules[count.index], "name", "${var.name}-sg-${count.index}")

  allow {
    protocol = lookup(var.security_rules[count.index], "proto", "all")
    # 22/22 => 22
    # 80/443 => 80-443
    ports = [
      join("-",
        [
          for x in sort(formatlist("%06d", distinct(split("/", var.security_rules[count.index]["port_range"])))) :
          tonumber(x)
      ])
    ]
  }

  target_tags = [var.name]

  source_ranges = can(var.security_rules[count.index]["cidr_ip"]) ? [var.security_rules[count.index]["cidr_ip"]] : null
  source_tags   = can(var.security_rules[count.index]["source_security_group_id"]) ? [var.security_rules[count.index]["source_security_group_id"]] : null

  direction   = upper(lookup(var.security_rules[count.index], "type", "INGRESS"))
  priority    = lookup(var.security_rules[count.index], "priority", 1000)
  description = lookup(var.security_rules[count.index], "description", "Security rule of ${var.name}")

}


# Allow all outbound rule adds only if no engress rules passed to module
resource "google_compute_firewall" "allow-outbound" {
  count   = var.number_of_instances > 0 ? (local.egress_rule_defined ? 0 : 1) : 0
  name    = "${var.name}-allow-outbound"
  network = data.google_compute_subnetwork.subnetwork.network

  target_tags = [var.name]

  allow {
    protocol = "all"
  }

  destination_ranges = ["0.0.0.0/0"]
  direction          = "EGRESS"
}
