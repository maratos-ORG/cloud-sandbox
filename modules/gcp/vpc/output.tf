output "vpc_id" {
  description = "The ID of the VPC"
  value       = google_compute_network.network.id
}

output "vpc_name" {
  description = "The Name of the VPC"
  value       = google_compute_network.network.name
}

output "nat_gateway_public_ips" {
  description = "The gateway address for default routing out of the network"
  value       = [google_compute_address.nat.address]
}

output "subnet_ids" {
  value = google_compute_subnetwork.subnets.*.id
}
