locals {
  base_tags = {
    vpc_id          = reverse(split("/", data.google_compute_subnetwork.subnetwork.network))[0]
    managed_by      = "terraform"
    team            = "devops"
    expiration_date = "never"
  }
}


data "google_compute_subnetwork" "subnetwork" {
  # projects/dba-test-430310/regions/europe-southwest1/subnetworks/stg-pop-es-mt-01-0 => stg-pop-es-mt-01-0
  name = reverse(split("/", var.subnet_ids[0]))[0]
}

data "google_compute_image" "this" {
  # to show all images see:
  # https://cloud.google.com/sdk/gcloud/reference/compute/images/list
  family  = var.image_id
  project = "ubuntu-os-cloud"
}

resource "google_compute_address" "external" {
  count        = var.associate_eip ? var.number_of_instances : 0
  name         = "${var.name}-${count.index}"
  address_type = "EXTERNAL"
}

resource "google_compute_instance" "this" {
  count        = var.number_of_instances
  name         = var.use_num_suffix ? format("%s%02d", var.name, count.index + 1) : var.name
  machine_type = var.instance_type
  zone         = element(var.availability_zones, count.index)
  metadata = {
    block-project-ssh-keys = !var.provision_project_ssh_keys 
  }
  metadata_startup_script = templatefile("${path.module}/user_data.sh", {
    hostname_base                                = var.name
    additional_user_data                         = var.additional_user_data
    hostname_use_public_ip                       = var.hostname_use_public_ip
  })
  deletion_protection       = var.deletion_protection
  can_ip_forward            = false
  allow_stopping_for_update = true

  network_interface {
    network    = data.google_compute_subnetwork.subnetwork.network
    subnetwork = var.subnet_ids[count.index % length(var.subnet_ids)]

    dynamic "access_config" {
      for_each = var.associate_eip ? [google_compute_address.external[count.index].address] : []
      content {
        nat_ip = access_config.value
      }
    }

  }

  boot_disk {
    initialize_params {
      image = data.google_compute_image.this.self_link
      size  = var.system_disk_size
    }
  }

  lifecycle {
    ignore_changes = [
      attached_disk,
      scratch_disk,
      boot_disk,
      metadata_startup_script
    ]
  }

  tags   = [var.name]
  labels = merge(local.base_tags, var.tags)
}

### Extra volumes
resource "google_compute_disk" "extra" {
  count = length(var.volumes) > 0 ? var.number_of_instances * length(var.volumes) : 0
  name = var.use_num_suffix ? format("%s-%s-%02d", var.name, lookup(var.volumes[count.index % length(var.volumes)], "resource_name"), floor(count.index / length(var.volumes)) + 1) : format("%s-%s", var.name, lookup(var.volumes[count.index % length(var.volumes)], "resource_name"))
  type  = lookup(var.volumes[count.index % length(var.volumes)], "device_type", "pd-standard")
  size = lookup(var.volumes[count.index % length(var.volumes)], "device_size")
  zone = element(var.availability_zones, floor(count.index / length(var.volumes)))
  labels = merge(local.base_tags, var.tags)
}

resource "google_compute_attached_disk" "extra" {
  count = length(var.volumes) > 0 ? var.number_of_instances * length(var.volumes) : 0
  # Get instance num - floor(count.index / length(var.ext_ebs))
  # Get disk num - count.index % length(var.ext_ebs)

  instance = google_compute_instance.this[floor(count.index / length(var.volumes))].id
  disk     = google_compute_disk.extra[count.index].id
}

