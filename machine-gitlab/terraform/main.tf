terraform {
  required_version = "0.12.25"
}

provider "google" {
  version = "2.15"
  project = var.project
  region = var.region
}

resource "google_compute_instance" "app" {
  count        = var.countIns
  name         = "gitlab-app-${count.index}"
  machine_type = "n1-standard-1"
  zone = var.zone
  tags = ["gitlab-app"]

  boot_disk {
    initialize_params {
      image = var.disk_image
      type = "pd-standard"
      size = "50"
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

resource "google_compute_firewall" "firewall_gitlab_ssh" {
  name    = "allow-gitlab-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["2222"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gitlab-app"]
}

resource "google_compute_firewall" "firewall_gitlab_http" {
  name    = "allow-gitlab-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gitlab-app"]
}

resource "google_compute_firewall" "firewall_gitlab_https" {
  name    = "allow-gitlab-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gitlab-app"]
}
