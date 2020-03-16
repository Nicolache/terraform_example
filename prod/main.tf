provider "google" {
  zone = "europe-west6-b"
  project = var.project
  region  = var.region
}

module "app" {
  source = "../modules/app"
  public_key_path = var.public_key_path
  app_disk_image = var.app_disk_image
}

module "db" {
  source = "../modules/db"
  public_key_path = var.public_key_path
  db_disk_image = var.db_disk_image
}

module "vpc" {
  source = "../modules/vpc"
  public_key_path = var.public_key_path
  source_ranges = ["94.241.0.0/16"]
  vpc_disk_image = var.vpc_disk_image
}

terraform {
  backend "gcs" {
#     credentials = "~/.config/gcloud/feisty-album-268710-fde9306b331d.json"
    credentials = "~/.config/gcloud/application_default_credentials.json"
    bucket  = "trudevops-states"
    prefix  = "trudevops-states/state"
  }
}
