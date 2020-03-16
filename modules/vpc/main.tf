resource "google_compute_instance" "vpc" {
  name         = "reddit-vpc"
  machine_type = "g1-small"
  tags         = ["reddit-vpc"]
  boot_disk {
    initialize_params {
      image = var.vpc_disk_image
    }
  }
  network_interface {
    network       = "default"
    access_config {}
  }
  metadata = {
    # sshKeys = "appuser:file(var.public_key_path)"
    sshKeys = "appuser:${file("${var.public_key_path}")}"
  }
}

# resource "google_compute_firewall" "firewall_mongo" {
#   name = "allow-mongo-default"
#   network = "default"
#   allow {
#     protocol = "tcp"
#     ports = ["27017"]
#   }
resource "google_compute_firewall" "firewall_ssh" {
  name= "default-allow-ssh"
  network = "default"
  allow {
  protocol = "tcp"
  ports= ["22"]
  }
  source_ranges = var.source_ranges
  # правило применимо к инстансам с тегом ...
  # target_tags = ["reddit-vpc"]
  # порт будет доступен только для инстансов с тегом ...
  source_tags = ["reddit-app"]
}
