locals {
  json_data = jsondecode(file("../uat2/${var.dataPath}"))
  data      = { for k, v in local.json_data : k => v }
}

resource "google_compute_snapshot" "snapshot" {
  for_each = local.data

  name        = "terraform-${each.value.snapshot.disk}-${each.value.snapshot.name}"
  source_disk = each.value.snapshot.disk

  project           = "projectA-prod"
  zone              = "asia-northeast2-a"
  storage_locations = ["asia-northeast2"]
}

resource "google_compute_address" "internal" {
  for_each = local.data

  name         = "${each.value.name}-private"
  address      = each.value.network.address
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = each.value.network.subnetwork

  depends_on = [
    google_compute_snapshot.snapshot
  ]
}

resource "google_compute_disk" "default" {
  for_each = local.data

  name     = each.value.name
  type     = var.diskType
  snapshot = "${var.snapshotPath}/terraform-${each.value.snapshot.disk}-${each.value.snapshot.name}"
  size     = each.value.size

  depends_on = [
    google_compute_address.internal
  ]
}

resource "google_compute_instance" "default" {
  for_each = local.data

  name         = each.value.name
  machine_type = each.value.type

  boot_disk {
    auto_delete = true
    device_name = each.value.name
    source      = each.value.name
  }

  network_interface {
    network            = each.value.network.vpc
    subnetwork         = each.value.network.subnetwork
    subnetwork_project = var.subnetwork_project
    network_ip         = each.value.network.address

    access_config {}
  }

  metadata = {
    block-project-ssh-keys = true
  }

  depends_on = [
    google_compute_disk.default
  ]
}
