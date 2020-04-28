terraform {
  required_version = "0.12.24"
}

provider "google" {
  version = "2.15"
  project = var.project
  region = var.region
}

resource "google_compute_instance" "app" {
  count        = var.countIns
  name         = "reddit-app-docker-${count.index}"
  machine_type = "g1-small"
  zone = var.zone
  tags = ["reddit-app-docker"]

  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "den_pirozhkov:${file(var.public_key_path)}"
  }

  connection {
    type  = "ssh"
    host  = self.network_interface[0].access_config[0].nat_ip
    user  = "den_pirozhkov"
    agent = false
    private_key = file(var.private_key_path)
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app-docker"]
}
