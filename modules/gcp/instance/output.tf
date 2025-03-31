output "instance_names" {
  value = length(google_compute_address.external[*].address) > 0 && var.hostname_use_public_ip ? [
    for k, v in google_compute_address.external[*].address :
    replace("${var.name}-${v}", ".", "-")
    ] : [
    for k, v in google_compute_instance.this[*].network_interface.0.network_ip :
    replace("${var.name}-${v}", ".", "-")
  ]
}

output "instance_volumes" {
  value = [for index, id in google_compute_instance.this[*].id :
    [for disk_index, disk in google_compute_instance.this[index].attached_disk[*] : {
      name        = lookup(var.volumes[disk_index], "name", null)
      device_name = "/dev/disk/by-id/google-${disk.device_name}"
      id          = disk.device_name
      size        = lookup(var.volumes[disk_index], "device_size", null)
    }]
  ]
}
output "instance_ids" {
  value = google_compute_instance.this[*].instance_id
}

output "instance_public_ips" {
  value = google_compute_address.external[*].address
}

output "instance_private_ips" {
  value = google_compute_instance.this[*].network_interface.0.network_ip
}

output "instance_sg" {
  value = var.name
}

output "network" {
  value = data.google_compute_subnetwork.subnetwork.network
}

output "number_of_instances" {
  value = var.number_of_instances
}

# # output "debug_security_rules" {
# #   value = var.security_rules
# # }