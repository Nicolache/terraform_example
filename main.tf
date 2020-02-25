provider "google" {
  # project = "feisty-album-268710"
  project = "${var.project}"
  region  = "europe-west1"
}

resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "europe-west6-b"
  tags         = ["reddit-app"]
  # определение загрузочного диска
  boot_disk {
    initialize_params {
      # image = "reddit-base-1582587704"
      image = "${var.disk_image}"
    }
  }
  metadata = {
    # sshKeys = "appuser:${file("~/.ssh/appuser.pub")}"
    sshKeys = "appuser:${file("${var.public_key_path}")}"
  }
  connection {
    host        = "${google_compute_instance.app.network_interface.0.access_config.0.nat_ip}"
    type        = "ssh"
    user        = "appuser"
    agent       = false
    # private_key = "${file("~/.ssh/appuser")}"
    private_key = "${file("${var.private_key_path}")}"
  }
  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }
  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"
    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с тегом ...
  target_tags = ["reddit-app"]
}

