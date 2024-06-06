resource "google_compute_instance" "vm_instance" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link
  }
}

resource "google_compute_network" "vpc_network" {
  name                  = var.vpc_network_name
  project               = var.project_id
  auto_create_subnetworks = var.auto_create_subnetworks
}
